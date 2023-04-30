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
        let data = #"{"name": "Alexandre"}"#.data(using: .utf8)
        
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
}

private extension AlamofireAdapterTests {
    
    func makeSut() -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        return AlamofireAdapter(session: session)
    }
    
    func testRequest(url: URL = URL(string: "https://any-url.com")!, data: Data?, completion: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        sut.post(url: url, with: data)
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
