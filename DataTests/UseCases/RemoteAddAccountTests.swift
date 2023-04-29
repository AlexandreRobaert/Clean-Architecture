//
//  DataTests.swift
//  DataTests
//
//  Created by Alexandre Robaert on 31/07/21.
//

import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpClient_with_url() throws {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel) { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url])
        XCTAssertEqual(httpClientSpy.callsAccount, 1)
    }
    
    func test_add_should_call_httpClient_with_correct_data() throws {
        let (sut, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel)  { _ in }
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_error() throws {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, expectedResult: .failure(.unexpected)) {
            httpClientSpy.completeWithError(.noConnectionError)
        }
    }
    
    func test_add_should_complete_with_Account_if_client_completes_with_valide_data() throws {
        let (sut, httpClientSpy) = makeSut()
        let account = makeAccountModel()
        expect(sut, expectedResult: .success(account)) {
            httpClientSpy.completeWithValidData(account.toData()!)
        }
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data() throws {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, expectedResult: .failure(.unexpected)) {
            httpClientSpy.completeWithInvalidData(Data("invalid_data".utf8))
        }
    }
}

private extension RemoteAddAccountTests {
    
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    func makeAddAccountModel()-> AddAccountModel {
        return AddAccountModel(name: "any name", email: "any email", password: "123456", passwordConfirmation: "123456")
    }
    
    func makeAccountModel()-> AccountModel {
        return AccountModel(id: "1", name: "any name", email: "any email", password: "123456")
    }
    
    func expect(_ sut: RemoteAddAccount, expectedResult: (Result<AccountModel, DomainError>), with action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "waiting")
        
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.failure(expectedError), .failure(receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case let (.success(expectedAccount), .success(receivedAccount)):
                XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            default: XCTFail("Esperava \(expectedResult) e devolveu \(receivedResult)", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
    
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
            completion?(.failure(.noConnectionError))
        }
        
        func completeWithValidData(_ data: Data) {
            completion?(.success(data))
        }
        
        func completeWithInvalidData(_ data: Data) {
            completion?(.success(data))
        }
    }
}
