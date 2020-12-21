//
//  BinaryCalculatorTests.swift
//  CalculatorTests
//
//  Created by 김태형 on 2020/12/15.
//

import XCTest
@testable import Calculator

final class BinaryCalculatorTests: XCTestCase {
    
    private var sut: BinaryCalculator!
    
    override func setUp() {
        super.setUp()
        sut = BinaryCalculator()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testAdd() {
        sut.handleInput("1100")
        sut.handleInput("+")
        sut.handleInput("11")
        sut.handleInput("=")
        
        XCTAssertEqual(sut.resultValue, "1111")
    }
    
    func testSubtract() {
        sut.handleInput("1100")
        sut.handleInput("-")
        sut.handleInput("11")
        sut.handleInput("=")
        
        XCTAssertEqual(sut.resultValue, "1001")
    }
    
    func testAnd() {
        sut.handleInput("1010")
        sut.handleInput("&")
        sut.handleInput("1011")
        sut.handleInput("=")
        
        XCTAssertEqual(sut.resultValue, "1010")
    }
    
    func testNand() {
        sut.handleInput("1010")
        sut.handleInput("~&")
        sut.handleInput("1111")
        sut.handleInput("=")
        
        XCTAssertEqual(sut.resultValue, "-1011")
    }
    
    func testOr() {
        sut.handleInput("1010")
        sut.handleInput("|")
        sut.handleInput("101")
        sut.handleInput("=")
        
        XCTAssertEqual(sut.resultValue, "1111")
    }
    
    func testNor() {
        sut.handleInput("1010")
        sut.handleInput("~|")
        sut.handleInput("1111")
        sut.handleInput("=")
        
        XCTAssertEqual(sut.resultValue, "-10000")
    }
    
    func testXor() {
        sut.handleInput("1111")
        sut.handleInput("^")
        sut.handleInput("1010")
        sut.handleInput("=")
        
        XCTAssertEqual(sut.resultValue, "101")
    }
    
    func testNot() {
        sut.handleInput("1100100")
        sut.handleInput("~")
        sut.handleInput("=")
        
        XCTAssertEqual(sut.resultValue, "-1100101")
    }
    
    func testLeftShift() {
        sut.handleInput("1010")
        sut.handleInput("<<")
        sut.handleInput("=")
        
        XCTAssertEqual(sut.resultValue, "10100")
    }
    
    func testRightShift() {
        sut.handleInput("1111")
        sut.handleInput(">>")
        sut.handleInput("=")
        
        XCTAssertEqual(sut.resultValue, "111")
    }
    
    func testIsOperator() {
        XCTAssertEqual(sut.isOperator("+"), true)
        XCTAssertEqual(sut.isOperator("-"), true)
        XCTAssertEqual(sut.isOperator("&"), true)
        XCTAssertEqual(sut.isOperator("~&"), true)
        XCTAssertEqual(sut.isOperator("|"), true)
        XCTAssertEqual(sut.isOperator("~|"), true)
        XCTAssertEqual(sut.isOperator("^"), true)
        XCTAssertEqual(sut.isOperator("~"), true)
        XCTAssertEqual(sut.isOperator("<<"), true)
        XCTAssertEqual(sut.isOperator(">>"), true)
        XCTAssertEqual(sut.isOperator("="), false)
        XCTAssertEqual(sut.isOperator(")"), false)
    }
    
    func testHandleDigit() {
        sut.handleInput("11111111")
        sut.handleInput("+")
        sut.handleInput("11111111")
        sut.handleInput("=")
        
        XCTAssertEqual(sut.resultValue, "111111110")
   }

}

