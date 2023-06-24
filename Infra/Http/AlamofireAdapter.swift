//
//  AlamofireAdapter.swift
//  Infra
//
//  Created by Alexandre Robaert on 06/05/23.
//

import Foundation
import Alamofire
import Data

public final class AlamofireAdapter: HttpPostClient {
    private let session: Session
    
    public init(session: Session = .default) {
        self.session = session
    }
    
    public func post(to url: URL, with data: Data?) async throws -> Data {
        
        return try await withCheckedThrowingContinuation { checkedContinuation in
            session.request(url, method: .post, parameters: data?.toDictionary(), encoding: JSONEncoding.default).responseData { dataResponse in
                guard let statusCode = dataResponse.response?.statusCode else {
                    return checkedContinuation.resume(throwing: HttpError.noConnectivityError)
                }
                
                switch dataResponse.result {
                case .success(let data):
                    switch statusCode {
                    case 204:
                        checkedContinuation.resume(throwing: HttpError.noContent)
                    case 200...299:
                        checkedContinuation.resume(returning: data)
                    case 401, 422:
                        checkedContinuation.resume(throwing: HttpError.unauthorizedError)
                    case 403:
                        checkedContinuation.resume(throwing: HttpError.forBidden)
                    case 400...499:
                        checkedContinuation.resume(throwing: HttpError.badRequestError)
                    case 500...599:
                        checkedContinuation.resume(throwing: HttpError.serverError)
                    default:
                        checkedContinuation.resume(throwing: HttpError.noConnectivityError)
                    }
                case .failure:
                    checkedContinuation.resume(throwing: HttpError.noConnectivityError)
                }
            }
        }
    }
}
