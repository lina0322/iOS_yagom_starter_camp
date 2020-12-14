//
//  Calculator.swift
//  Calculator
//
//  Created by 김태형 on 2020/12/11.
//

import Foundation

class Calculator {
    var currentMode: CalculatorMode
    var postfix: [String] = []
    var stack: Stack = Stack()
    var resultValue = Constants.zero
    var operators: [String] = OperatorType.allCases.map {
        type -> String in return type.rawValue
    }
    
    init(calculatorMode: CalculatorMode) {
        currentMode = calculatorMode
        operators = operators.filter ({ (value: String) -> Bool in
            if let `operator` = OperatorType(rawValue: value) {
                let isEqualing = `operator`.mode == CalculatorMode.common || `operator`.mode == currentMode
                return isEqualing
            }
            return false
        })
    }
    
    func handleInput(_ input: String) {
        if isOperator(input) {
            handleOperator(input)
        } else if isEqual(input) {
            popAllValuesToPostfix()
            handlePostfix()
            allClear()
        } else {
            postfix.append(input)
        }
    }
    
    func handleOperator(_ input: String) {
        if stack.isEmpty() {
            stack.push(input)
        } else {
            guard let `operator` = OperatorType(rawValue: input),
                  let peekedValue = stack.peek(),
                  let peekedOperator = OperatorType(rawValue: peekedValue) else {
                return
            }
            if `operator`.isHighPriority(than: peekedOperator) {
                stack.push(input)
            } else if `operator`.isLowPriority(than: peekedOperator) {
                popAllValuesToPostfix()
                stack.push(input)
            } else {
                guard let popedValue = stack.pop() else {
                    return
                }
                postfix.append(popedValue)
                stack.push(input)
            }
        }
    }
    
    func handlePostfix() {
        for postfixValue in postfix {
            if operators.contains(postfixValue) {
                determineOperatorType(operator: postfixValue)
            } else {
                stack.push(postfixValue)
            }
        }
        guard let stackLastValue = stack.pop() else {
            return
        }
        handleDigit(stackLastValue)
    }
    
    func determineOperatorType(`operator`: String) {
        guard let calculatorOperator = OperatorType(rawValue: `operator`),
              let secondValue = stack.pop(),
              let firstValue = stack.pop() else {
            return
        }
        let result = operate(calculatorOperator: calculatorOperator, firstValue: firstValue, secondValue: secondValue)
        stack.push(result)
        postfix.removeFirst()
    }
    
    func operate(calculatorOperator: OperatorType, firstValue: String, secondValue: String = Constants.zero) -> String {
        if currentMode == CalculatorMode.binary {
            guard let firstNumber = Int(firstValue),
                  let secondNumber = Int(secondValue) else {
                return Constants.zero
            }
            switch calculatorOperator {
            case .add:
                return String(firstNumber + secondNumber, radix: 2)
            case .subtract:
                return String(firstNumber - secondNumber, radix: 2)
            default:
                return Constants.zero
            }
        } else {
            guard let firstNumber = Double(firstValue),
                  let secondNumber = Double(secondValue) else {
                return Constants.zero
            }
            switch calculatorOperator {
            case .add:
                return String(firstNumber + secondNumber)
            case .subtract:
                return String(firstNumber - secondNumber)
            default:
                return Constants.zero
            }
        }
        
    }
    
    func handleDigit(_ fullNumber: String) {
        let offsetLength = fullNumber.count > Constants.maxLength  ? Constants.maxLength : fullNumber.count - 1
        let endIndex = fullNumber.index(fullNumber.startIndex, offsetBy: offsetLength)
        resultValue = String(fullNumber[...endIndex])
    }
    
    func isOperator(_ input: String) -> Bool {
        return operators.contains(input)
    }
    
    func isEqual(_ input: String) -> Bool {
        return input == Constants.equal
    }
    
    func popAllValuesToPostfix() {
        let remainingValues = stack.stack
        for _ in remainingValues {
            postfix.append(stack.pop()!)
        }
    }
    
    func allClear() {
        stack.removeAll()
        postfix.removeAll()
    }
}

extension Array {
    func isNotEmpty() -> Bool {
        return !isEmpty
    }
}
