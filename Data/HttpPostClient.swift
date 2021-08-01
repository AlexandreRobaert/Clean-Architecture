//
//  HttpPostCliente.swift
//  Data
//
//  Created by Alexandre Robaert on 01/08/21.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}
