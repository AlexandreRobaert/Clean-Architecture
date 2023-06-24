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
    var completionData: (data: Data?, error: HttpError?)
    
    func post(to url: URL, with data: Data?) async throws -> Data {
        self.urls.append(url)
        self.data = data
        self.callsAccount += 1
        guard let data = completionData.data else {
            throw completionData.error ?? .noConnectivityError
        }
        return data
    }
    
    func completeWithError(_ error: HttpError) {
        completionData.error = error
    }
    
    func completeWithValidData(_ data: Data) {
        completionData.data = data
    }
    
    func completeWithInvalidData(_ data: Data) {
        completionData.data = data
    }
}
