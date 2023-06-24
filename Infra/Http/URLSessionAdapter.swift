//
//  URLSessionAdapter.swift
//  Infra
//
//  Created by Alexandre Robaert on 24/06/23.
//  Copyright © 2023 Alexandre Robaert. All rights reserved.
//

import Foundation
import Data

public class URLSessionAdapter: HttpPostClient {
    
    private let session: URLSessionConfiguration
    private var urlSession: URLSession {
        URLSession(configuration: session)
    }
    
    public init(session: URLSessionConfiguration = .default) {
        self.session = session
    }
    
    public func post(to url: URL, with data: Data?) async throws -> Data {
        let (data, urlResponse) = try await urlSession.data(from: url)
        guard let response  = urlResponse as? HTTPURLResponse else {
            throw HttpError.badRequestError
        }
        
        switch response.statusCode {
        case 204:
            throw HttpError.noContent
        case 200...299:
            return data
        case 401, 422:
            throw HttpError.unauthorizedError
        case 403:
            throw HttpError.forBidden
        case 400...499:
            throw HttpError.badRequestError
        case 500...599:
            throw HttpError.serverError
        default:
            throw HttpError.noConnectivityError
        }
    }
}
