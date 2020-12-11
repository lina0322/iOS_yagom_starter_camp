//
//  Stack.swift
//  Calculator
//
//  Created by 김태형 on 2020/12/11.
//

import Foundation

struct Stack {
    var stack = [String]()
    
    mutating func push(_ value: String) {
        stack.append(value)
    }
    
    mutating func pop() -> String? {
        return stack.popLast()
    }
    
    func peek() -> String? {
        return stack.last
    }
    
    mutating func removeAll() {
        stack.removeAll()
    }
    
    func isEmpty() -> Bool {
        return stack.isEmpty
    }
    
    func isNotEmpty() -> Bool {
        return !stack.isEmpty
    }
}
