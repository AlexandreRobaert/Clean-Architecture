//
//  HttpClienteSpy.swift
//  DataTests
//
//  Created by Alexandre Robaert on 29/04/23.
//

import Foundation
import Data

class HttpClientSpy: HttpPostClient {
    
    var urls: [URL] = []
    var data: Data?
    var callsAccount = 0
    var completion: ((Result<Data, HttpError>) -> Void)?
    
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
        self.urls.append(url)
        self.data = data
        self.callsAccount += 1
        self.completion = completion
    }
    
    func completeWithError(_ error: HttpError) {
        completion?(.failure(.noConnectivityError))
    }
    
    func completeWithValidData(_ data: Data) {
        completion?(.success(data))
    }
    
    func completeWithInvalidData(_ data: Data) {
        completion?(.success(data))
    }
}
