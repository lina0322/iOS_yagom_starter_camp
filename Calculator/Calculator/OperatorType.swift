//
//  OperatorType.swift
//  Calculator
//
//  Created by 김태형 on 2020/12/12.
//

import Foundation

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
    

}
