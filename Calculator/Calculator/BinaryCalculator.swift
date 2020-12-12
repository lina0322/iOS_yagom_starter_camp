class BinaryCalculator: Calculator {
    
    init() {
            super.init(calculatorMode: .binary)
        }
    
    override func determineOperatorType(operator: String) {
        if `operator` == OperatorType.not.rawValue || `operator` == OperatorType.rightShift.rawValue || `operator` == OperatorType.leftShift.rawValue {
            guard let calculatorOperator = OperatorType(rawValue: `operator`),
                  let firstValue = stack.pop() else { return }
            let result = operate(calculatorOperator: calculatorOperator, firstValue: firstValue)
            stack.push(result)
            postfix.removeFirst()
        } else {
            super.determineOperatorType(operator: `operator`)
        }
    }
}
