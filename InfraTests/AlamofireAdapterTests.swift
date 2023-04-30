//
//  AlamofireAdapterTests.swift
//  DataTests
//
//  Created by Alexandre Robaert on 29/04/23.
//

import XCTest
import Alamofire
import Data

class AlamofireAdapter {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
        session.request(url, method: .post, parameters: data?.toDictionary(), encoding: JSONEncoding.default).responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                break
            case .failure:
                completion(.failure(.noConnectivityError))
            }
        }
    }
}

final class AlamofireAdapterTests: XCTestCase {

    func test_post_request_alamofire_url_e_method_e_contem_dados() throws {
        let url = makeURL()
        let data = validData()
        
        testRequest(url: url, data: data) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual(HTTPMethod.post.rawValue, request.method?.rawValue)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }
    
    func test_post_request_alamofire_sem_dados() throws {
    
        testRequest(data: nil) { request in
            XCTAssertNil(request.httpBodyStream)
        }
    }
    
    func test_post_com_error_deve_completar_com_error() throws {
    
        let sut = makeSut()
        let expectation = expectation(description: "Fazendo o request")
        URLProtocolStub.simulateResult(data: nil, response: nil, error: makeError())
        sut.post(url: makeURL(), with: validData()) { result in
            switch result {
            case .success(let success):
                XCTFail("Erro não esperado, deveria retornar com Erro, mas retornou \(success)")
            case .failure(let failure):
                XCTAssertEqual(failure, .noConnectivityError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}

private extension AlamofireAdapterTests {
    
    func makeSut(file: StaticString = #file, line: UInt = #line) -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        checkMemoryLeak(instance: sut, file: file, line: line)
        return sut
    }
    
    func testRequest(url: URL = makeURL(), data: Data?, completion: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        sut.post(url: url, with: data) {_ in }
        let expectation = expectation(description: "Fazendo o Post")
        URLProtocolStub.observerCompletion { request in
            completion(request)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}


class URLProtocolStub: URLProtocol {
    
    static var emit: ((URLRequest) -> Void)?
    static var result: (data: Data?, response: HTTPURLResponse?, error: Error?)
    
    static func observerCompletion(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
    }
    
    static func simulateResult(data: Data?, response: HTTPURLResponse?, error: Error?) {
        result.data = data
        result.response = response
        result.error = error
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        
        // Se true diz que quero interceptar todo o request
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        URLProtocolStub.emit?(request)
        if let data = URLProtocolStub.result.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = URLProtocolStub.result.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = URLProtocolStub.result.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
