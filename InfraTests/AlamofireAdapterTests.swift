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
    
    func post(url: URL) {
        session.request(url, method: .post).resume()
    }
}

final class AlamofireAdapterTests: XCTestCase {

    func test_post_request_alamofire_url_e_method_corretos() throws {
        let url = URL(string: "https://any-url.com")!
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        let expectation = expectation(description: "Fazendo o Post")
        sut.post(url: url)
        URLProtocolStub.observerCompletion { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual(HTTPMethod.post.rawValue, request.method?.rawValue)
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
