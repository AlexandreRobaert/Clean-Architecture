//
//  AlamofireAdapterTests.swift
//  DataTests
//
//  Created by Alexandre Robaert on 29/04/23.
//

import XCTest
import Alamofire

class AlamofireAdapter {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(url: URL, with data: Data?) {
        let json = data == nil ? nil : try? JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as? [String: Any]
        session.request(url, method: .post, parameters: json, encoding: JSONEncoding.default).resume()
    }
}

final class AlamofireAdapterTests: XCTestCase {

    func test_post_request_alamofire_url_e_method_corretos() throws {
        let url = URL(string: "https://any-url.com")!
        let sut = makeSut()
        let expectation = expectation(description: "Fazendo o Post")
        
        let data = #"{"name": "Alexandre"}"#.data(using: .utf8)
        
        sut.post(url: url, with: data)
        URLProtocolStub.observerCompletion { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual(HTTPMethod.post.rawValue, request.method?.rawValue)
            XCTAssertNotNil(request.httpBodyStream)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_post_request_alamofire_sem_dados() throws {
    
        let sut = makeSut()
        let expectation = expectation(description: "Fazendo o Post")
        sut.post(url: URL(string: "https://any-url.com")!, with: nil)
        URLProtocolStub.observerCompletion { request in
            XCTAssertNil(request.httpBodyStream)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}

private extension AlamofireAdapterTests {
    
    func makeSut() -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        return AlamofireAdapter(session: session)
    }
}


class URLProtocolStub: URLProtocol {
    
    static var emit: ((URLRequest) -> Void)?
    
    static func observerCompletion(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
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
    }
    
    override func stopLoading() {
        
    }
}
