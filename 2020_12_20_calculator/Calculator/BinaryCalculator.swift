//
//  BinaryCalculator.swift
//  Calculator
//
//  Created by 김태형 on 2020/12/11.
//

class BinaryCalculator: Calculator {
    init() {
        super.init(calculatorMode: .binary)
    }
    
    override func determineOperatorType(operator: String) {
        if `operator` == OperatorType.not.rawValue || `operator` == OperatorType.rightShift.rawValue || `operator` == OperatorType.leftShift.rawValue {
            guard let calculatorOperator = OperatorType(rawValue: `operator`),
                  let firstValue = stack.pop() else {
                return
            }
            let result = operate(calculatorOperator: calculatorOperator, firstValue: firstValue)
            stack.push(result)
            postfix.removeFirst()
        } else {
            super.determineOperatorType(operator: `operator`)
        }
    }
    
    override func operate(calculatorOperator: OperatorType, firstValue: String, secondValue: String = Constants.zero) -> String {
        guard let firstNumber = Int(firstValue, radix: 2),
              let secondNumber = Int(secondValue, radix: 2) else {
            return Constants.zero
        }
        switch calculatorOperator {
        case .add:
            return String(firstNumber + secondNumber, radix: 2)
        case .subtract:
            return String(firstNumber - secondNumber, radix: 2)
        case .and:
            return String(firstNumber & secondNumber, radix: 2)
        case .nand:
            return String(~(firstNumber & secondNumber), radix: 2)
        case .or:
            return String(firstNumber | secondNumber, radix: 2)
        case .nor:
            return String(~(firstNumber | secondNumber), radix: 2)
        case .xor:
            return String(firstNumber ^ secondNumber, radix: 2)
        case .not:
            return String(~firstNumber, radix: 2)
        case .leftShift:
            return String(firstNumber << 1, radix: 2)
        case .rightShift:
            return String(firstNumber >> 1, radix: 2)
        default:
            return Constants.zero
        }
    }
}
