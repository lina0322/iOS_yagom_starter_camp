
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
            handleOperator(input)
        } else if isEqual(input) {
            popAllStackToPostfix()
            //handlePostfix()
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
                  let peekedOperator = OperatorType(rawValue: peekedValue) else { return }
            
            if `operator`.isHighPriority(than: peekedOperator) {
                stack.push(input)
            } else if `operator`.isLowPriority(than: peekedOperator) {
                popAllStackToPostfix()
                stack.push(input)
            } else {
                guard let popedValue = stack.pop() else { return }
                postfix.append(popedValue)
                stack.push(input)
            }
        }
    }
    
    func handlePostfix() {
        for postfixValue in postfix {
            if operators.contains(postfixValue) {
                //determineOperatorType(operator: postfixValue)
            } else {
                stack.push(postfixValue)
            }
        }
        guard let stackLastValue = stack.pop() else { return }
        handleDigit(stackLastValue)
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
