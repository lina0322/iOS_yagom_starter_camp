//
//  Calculator.swift
//  Calculator
//
//  Created by 김태형 on 2020/12/07.
//

import Foundation

class Calculator {
    static let common = Calculator()
    private init() {}
    
    var currentValue: Double = 0
    var valueToBeCalculated: Double = 0
    var performingOperation: Bool = false
    
    func add() {
        Calculator.common.currentValue = Calculator.common.currentValue + Calculator.common.valueToBeCalculated
    }
    
    func substract() {
        Calculator.common.currentValue = Calculator.common.currentValue - Calculator.common.valueToBeCalculated
    }
    
    func multiple() {
        Calculator.common.currentValue = Calculator.common.currentValue * Calculator.common.valueToBeCalculated
    }
    
}

class DecimalOperator {
    func division() {
        Calculator.common.currentValue = Calculator.common.currentValue / Calculator.common.valueToBeCalculated
    }
}

class BinaryOperator {
    func andOperate() {
    }
}

class Clear {
    func clear() {
        Calculator.common.valueToBeCalculated = 0
        Calculator.common.currentValue = 0
    }
}

class TypeChanger {
    func StringToInteger(input: String) -> Int {
        guard let inputValue = Int(input, radix: 2) else { return 0 }
        return inputValue
    }
    
    func IntegerToString(input: Int) -> String {
        let convertedValue = String(input, radix: 2)
        return convertedValue
    }
}
