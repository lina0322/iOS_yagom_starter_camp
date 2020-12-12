
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
    
    func handleInput(_ input: String) {
        if isOperator(input) {
            //handleOperator(input)
        } else if isEqual(input) {
            popAllStackToPostfix()
            //handlePostfix()
            allClear()
        } else {
            postfix.append(input)
        }
    }
    
    func isOperator(_ input: String) -> Bool {
        return operators.contains(input)
    }
    
    func isEqual(_ input: String) -> Bool {
        return input == Constants.equal
    }
    
    func popAllStackToPostfix() {
        while !stack.isEmpty() {
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
