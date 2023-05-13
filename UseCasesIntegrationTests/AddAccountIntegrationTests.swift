//
//  UseCasesIntegrationTests.swift
//  UseCasesIntegrationTests
//
//  Created by Alexandre Robaert on 07/05/23.
//

import XCTest
import Data
import Infra
import Domain

final class AddAccountIntegrationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddAccount() throws {
//        let url = URL(string: "https://demo3129794.mockable.io/api/alexandre/siginup")!
//        let alamofireAdapter = AlamofireAdapter()
//        let sut = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
//        let addAccountModel = AddAccountModel(name: "Alexandre Robaert", email: "alexandre@email.com", password: "123456", passwordConfirmation: "123456")
//        let exp = expectation(description: "Waiting")
//        sut.add(addAccountModel: addAccountModel) { result in
//            switch result {
//            case .success(let account):
//                XCTAssertNotNil(account.id)
//                XCTAssertEqual(account.name, addAccountModel.name)
//                XCTAssertEqual(account.email, addAccountModel.email)
//                exp.fulfill()
//            case .failure:
//                XCTFail("Esperava Sucesso e retornou \(result)")
//            }
//        }
//        wait(for: [exp], timeout: 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
