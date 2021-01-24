//
//  DecimalCalculator.swift
//  Calculator
//
//  Created by 김태형 on 2020/12/11.
//

class DecimalCalculator : Calculator {
    var isDividingByZero: Bool = false
    
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
            guard secondNumber != 0 else {
                isDividingByZero = true
                return Constants.error
            }
            return String(firstNumber / secondNumber)
        default:
            return Constants.zero
        }
    }
    
    override func handleDigit(_ fullNumber: String) {
        if isDividingByZero {
            resultValue = Constants.error
            return 
        }
        
        let frontNumber = fullNumber.components(separatedBy: Constants.dot)[0]
        if frontNumber.count > Constants.maxLength {
            let offsetLength = frontNumber.count - Constants.maxLength
            let startIndex = frontNumber.index(frontNumber.startIndex, offsetBy: offsetLength)
            resultValue = String(frontNumber[startIndex...])
        } else {
            super.handleDigit(fullNumber)
        }
        if resultValue.hasSuffix(Constants.dotZero) {
            resultValue.removeLast()
            resultValue.removeLast()
        }
        if fullNumber.hasPrefix(Constants.minus) && !resultValue.hasPrefix(Constants.minus) {
            resultValue = Constants.minus + resultValue
        }
    }
}
