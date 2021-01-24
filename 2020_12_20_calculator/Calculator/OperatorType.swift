//
//  OperatorType.swift
//  Calculator
//
//  Created by 김태형 on 2020/12/12.
//

enum OperatorType: String, CaseIterable {
    case add = "+"
    case subtract = "-"
    case multiple = "*"
    case divide = "/"
    case and = "&"
    case nand = "~&"
    case or = "|"
    case nor = "~|"
    case xor = "^"
    case not = "~"
    case leftShift = "<<"
    case rightShift = ">>"
    
    var mode: CalculatorMode {
        switch self {
        case .add, .subtract:
            return .common
        case .multiple, .divide:
            return .decimal
        default:
            return .binary
        }
    }
    
    var priority: Int {
        switch self {
        case .multiple, .divide, .not, .nand, .nor:
            return 100
        case .add, .subtract:
            return 90
        case .leftShift, .rightShift:
            return 80
        case .and:
            return 70
        case .xor:
            return 60
        case .or:
            return 50
        }
    }
    
    func isHighPriority(than input: OperatorType) -> Bool {
        let operatorPriority = self.priority - input.priority
        return operatorPriority > 0
    }
    
    func isLowPriority(than input: OperatorType) -> Bool {
        let operatorPriority = self.priority - input.priority
        return operatorPriority < 0
    }
}
