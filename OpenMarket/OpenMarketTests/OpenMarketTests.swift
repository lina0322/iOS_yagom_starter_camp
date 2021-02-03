//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 임리나 on 2021/01/25.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    func testLoadFirstPageFromMockSuccessCase() {
        let productList = loadPageFromMock(1, success: true)
        dump(productList)
        XCTAssertNotNil(productList)
        XCTAssertEqual(productList?.page, 1)
        XCTAssertEqual(productList?.items.count, 20)
    }

    func testLoadFirstPageFromMockFailureCase() {
        let productList = loadPageFromMock(1, success: false)
        dump(productList)
        XCTAssertNil(productList)
    }
    
    func testLoadProductFromMockSuccessCase() {
        let product = loadProductFromMock(1, success: true)
        dump(product)
        XCTAssertNotNil(product)
        XCTAssertEqual(product?.id, 1)
    }

    func testLoadProductFromMockFailureCase() {
        let product = loadProductFromMock(1, success: false)
        dump(product)
        XCTAssertNil(product)
    }
    
    func testLoadFirstPage() {
        let productList = loadPage(1)
        dump(productList)
        XCTAssertNotNil(productList)
        XCTAssertEqual(productList?.page, 1)
        XCTAssertEqual(productList?.items.count, 20)
    }
    
    func testLoadSecondPage() {
        let productList = loadPage(2)
        XCTAssertNotNil(productList)
        XCTAssertEqual(productList?.page, 2)
        XCTAssertEqual(productList?.items.count, 20)
    }
    
    func testLoadThridPage() {
        let productList = loadPage(3)
        XCTAssertNotNil(productList)
        XCTAssertEqual(productList?.page, 3)
        print(productList?.items.count ?? 0)
    }
    
    func testLoadFourthPage() {
        let productList = loadPage(4)
        XCTAssertNotNil(productList)
        XCTAssertEqual(productList?.page, 4)
        print(productList?.items.count ?? 0)
    }
    
    func testLoadItem1() {
        let item = loadProduct(32)
        dump(item)
        XCTAssertNotNil(item)
        XCTAssertEqual(item?.id, 32)
    }
    
    func testLoadItem2() {
        let item = loadProduct(42)
        dump(item)
        XCTAssertNotNil(item)
        XCTAssertEqual(item?.id, 42)
    }
    
    func testPatchItem1() {
        patchProduct(101)
    }
    
    func testPatchItem2() {
        patchProduct(141)
    }
    
    func testPostItem1() {
        postProduct()
    }
    
    func testPostItem2() {
        postProduct()
    }
}

extension OpenMarketTests {
    func loadPageFromMock(_ number: Int, success: Bool) -> ProductList? {
        let expectation = XCTestExpectation(description: "pageLoad")
        var productList: ProductList?
        let networkHandler = NetworkHandler(session: MockURLSession(isSuccess: success, apiRequestType: .loadPage(page: number)))
        
        OpenMarketJSONDecoder<ProductList>.decodeData(about: .loadPage(page: number), networkHandler: networkHandler) { result in
            switch result {
            case .success(let data):
                productList = data
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        return productList
    }
    
    func loadProductFromMock(_ number: Int, success: Bool) -> Product? {
        let expectation = XCTestExpectation(description: "pageLoad")
        var product: Product?
        let networkHandler = NetworkHandler(session: MockURLSession(isSuccess: success, apiRequestType: .loadProduct(id: number)))
        
        OpenMarketJSONDecoder<Product>.decodeData(about: .loadProduct(id: number), networkHandler: networkHandler) { result in
            switch result {
            case .success(let data):
                product = data
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        return product
    }
    
    func loadPage(_ number: Int) -> ProductList? {
        let expectation = XCTestExpectation(description: "pageLoad")
        var productList: ProductList?
        
        OpenMarketJSONDecoder<ProductList>.decodeData(about: .loadPage(page: number)) { result in
            switch result {
            case .success(let data):
                productList = data
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        return productList
    }
    
    func loadProduct(_ id: Int) -> Product? {
        let expectation = XCTestExpectation(description: "itemLoad")
        var product: Product?
        
        OpenMarketJSONDecoder<Product>.decodeData(about: .loadProduct(id: id)) { result in
            switch result {
            case .success(let data):
                product = data
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        return product
    }
    
    func patchProduct(_ id: Int) {
        let expectation = XCTestExpectation(description: "itemPatch")
        let imageData = UIImage(systemName: "house")!.pngData()!
        let product = Product(forPatchPassword: "12345", id: id, discountedPrice: 100000000)
        
        Uploader.uploadData(by: .patch, product: product, apiRequestType: .patchProduct(id: id)) { result in
            switch result {
            case .success(let data):
                dump(data)
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func postProduct() {
        let expectation = XCTestExpectation(description: "itemPatch")
        let imageData = UIImage(systemName: "house")!.pngData()!
        let product = Product(forPostPassword: "12345", title: "Mac House air", descriptions: "password 12345\n This is my Mac House air. I wanna sell this, cuz I need money~ yeah!", price: 200000000, currency: "KRW", stock: 1, discountedPrice: 100000000, imageFiles: [imageData])
        
        Uploader.uploadData(by: .post, product: product, apiRequestType: .postProduct) { result in
            switch result {
            case .success(let data):
                dump(data)
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
