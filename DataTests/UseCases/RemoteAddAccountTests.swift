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
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel())  { result in
            switch result {
            case .success:
                XCTFail("Expected error received: \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectionError)
        wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_valide_data() throws {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let expectedAccount = makeAccountModel()
        sut.add(addAccountModel: makeAddAccountModel())  { result in
            switch result {
            case .failure:
                XCTFail("Expected success received: \(result) instead")
            case .success(let receivedAccount):
                XCTAssertEqual(receivedAccount, expectedAccount)
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithValidData(expectedAccount.toData()!)
        wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data() throws {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel())  { result in
            switch result {
            case .success:
                XCTFail("Expected error received: \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithInvalidData(Data("invalid_data".utf8))
        wait(for: [exp], timeout: 1)
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
