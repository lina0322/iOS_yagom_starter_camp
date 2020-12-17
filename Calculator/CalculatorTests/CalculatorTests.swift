//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by 김태형 on 2020/12/15.
//

import XCTest
@testable import Calculator

final class CalculatorTests: XCTestCase {

    private var sut: Calculator!
    
    override func setUp() {
        super.setUp()
        sut = Calculator(calculatorMode: .common)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testIsEqual() {
        XCTAssertEqual(sut.isEqual("="), true)
        XCTAssertEqual(sut.isEqual("*"), false)
    }
}
