//
//  HttpError.swift
//  Data
//
//  Created by Alexandre Robaert on 16/04/23.
//

import Foundation

public enum HttpError: Error {
    case noConnectivityError
    case noContent
    case badRequestError
    case serverError
    case parseError
    case unauthorizedError
    case forBidden
}
