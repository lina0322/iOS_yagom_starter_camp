
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
                return `operator`.mode == CalculatorMode.common || `operator`.mode == currentMode
            }
            return false
        })
    }
}
