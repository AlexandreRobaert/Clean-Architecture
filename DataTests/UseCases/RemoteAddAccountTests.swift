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
            httpClientSpy.completeWithError(.noConnectivityError)
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
    
    func test_add_should_not_complete_if_sut_has_been_deallocated() throws {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: URL(string: "http://any-url.com")!, httpClient: httpClientSpy)
        var expectedResult: Result<AccountModel, DomainError>?
        sut?.add(addAccountModel: makeAddAccountModel(), completion: { result in
            expectedResult = result
        })
        sut = nil
        httpClientSpy.completeWithError(.noConnectivityError)
        XCTAssertNil(expectedResult)
    }
}

private extension RemoteAddAccountTests {
    
    func makeSut(url: URL = URL(string: "http://any-url.com")!,
                 file: StaticString = #file, line: UInt = #line) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(instance: sut, file: file, line: line)
        checkMemoryLeak(instance: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
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
}
