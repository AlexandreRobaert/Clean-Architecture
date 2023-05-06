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
    
    public func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        session.request(url, method: .post, parameters: data?.toDictionary(), encoding: JSONEncoding.default).responseData { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else {
                return completion(.failure(.noConnectivityError))
            }
            
            switch dataResponse.result {
            case .success(let data):
                switch statusCode {
                case 204:
                    completion(.success(nil))
                case 200...299:
                    completion(.success(data))
                case 401, 422:
                    completion(.failure(.unauthorizedError))
                case 403:
                    completion(.failure(.forBidden))
                case 400...499:
                    completion(.failure(.badRequestError))
                case 500...599:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.noConnectivityError))
                }
            case .failure:
                completion(.failure(.noConnectivityError))
            }
        }
    }
}
