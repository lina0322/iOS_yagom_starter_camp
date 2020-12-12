
class DecimalCalculator : Calculator {
    
    init() {
            super.init(calculatorMode: .decimal)
        }
    
    override func operate(calculatorOperator: OperatorType, firstValue: String, secondValue: String = Constants.zero) -> String {
        guard let firstNumber = Double(firstValue),
              let secondNumber = Double(secondValue) else { return Constants.zero }
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
}
