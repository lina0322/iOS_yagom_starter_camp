//
//  DecimalCalculator.swift
//  Calculator
//
//  Created by 김태형 on 2020/12/11.
//

class DecimalCalculator : Calculator {
    init() {
        super.init(calculatorMode: .decimal)
    }
    
    override func operate(calculatorOperator: OperatorType, firstValue: String, secondValue: String = Constants.zero) -> String {
        guard let firstNumber = Double(firstValue),
              let secondNumber = Double(secondValue) else {
            return Constants.zero
        }
        switch calculatorOperator {
        case .add:
            return String(firstNumber + secondNumber)
        case .subtract:
            return String(firstNumber - secondNumber)
        case .multiple:
            return String(firstNumber * secondNumber)
        case .divide:
            return String(firstNumber / secondNumber)
        default:
            return Constants.zero
        }
    }
    
    override func handleDigit(_ fullNumber: String) {
        let frontNumber = fullNumber.components(separatedBy: Constants.dot)[0]
        if frontNumber.count > Constants.maxLength {
            let offsetLength = frontNumber.count - Constants.maxLength
            let startIndex = frontNumber.index(frontNumber.startIndex, offsetBy: offsetLength)
            resultValue = String(frontNumber[startIndex...])
        } else {
            super.handleDigit(fullNumber)
        }
        if resultValue.hasSuffix(Constants.zero) { resultValue.removeLast() }
        if resultValue.hasSuffix(Constants.dot) { resultValue.removeLast() }
    }
}
