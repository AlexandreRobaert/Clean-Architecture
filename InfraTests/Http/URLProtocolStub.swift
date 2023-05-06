//
//  URLProtocolStub.swift
//  Infra
//
//  Created by Alexandre Robaert on 06/05/23.
//

import Foundation

class URLProtocolStub: URLProtocol {
    
    static var emit: ((URLRequest) -> Void)?
    static var simulateResult: (data: Data?, response: HTTPURLResponse?, error: Error?)
    
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
        if let data = URLProtocolStub.simulateResult.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = URLProtocolStub.simulateResult.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = URLProtocolStub.simulateResult.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
