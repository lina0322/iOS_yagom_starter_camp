//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 임리나 on 2021/01/25.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    func testProduct() {
        let expectation = XCTestExpectation(description: "APIaskExpectation")
        var productList: Products?

        ProductJSONDecoder.decodeData() { result in
            switch result {
            case .success(let data):
                productList = data
            case .failure(let error):
                print(error.description)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
   
        dump(productList)
        XCTAssertNotNil(productList)
        XCTAssertEqual(productList?.list.count, 20)
    }
}
