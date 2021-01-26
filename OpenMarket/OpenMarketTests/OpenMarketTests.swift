import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
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
            let item = loadItem(32)
            dump(item)
            XCTAssertNotNil(item)
            XCTAssertEqual(item?.id, 32)
        }
        
        func testLoadItem2(){
            let item = loadItem(42)
            dump(item)
            XCTAssertNotNil(item)
            XCTAssertEqual(item?.id, 42)
        }
}

extension OpenMarketTests {
    func loadPage(_ number: Int) -> ProductList? {
        let expectation = XCTestExpectation(description: "APIaskExpectation")
        var productList: ProductList?
        

        OpenMarketJSONDecoder<ProductList>.decodeData(about: .page, specificNumer: number) { result in
            switch result {
            case .success(let data):
                productList = data
            case .failure(let error):
                print("error: \(error.description)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        return productList
    }
    
    func loadItem(_ id: Int) -> Product? {
        let expectation = XCTestExpectation(description: "APIaskExpectation")
        var product: Product?
        
        OpenMarketJSONDecoder<Product>.decodeData(about: .product, specificNumer: id) { result in
            switch result {
            case .success(let data):
                product = data
            case .failure(let error):
                print("error: \(error.description)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        return product
    }
}
