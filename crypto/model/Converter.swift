//
//  Converter.swift
//  crypto
//
//  Created by Sreejith CR on 18/07/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import Foundation

struct Converter {
    
    private static func calculate(input1: NSDecimalNumber, input2: NSDecimalNumber, operation: Operator) -> String  {
        
        switch operation {
        case .add : return (input1.adding(input2)).stringValue
        case .substract: return (input1.subtracting(input2)).stringValue
        case .multiply: return (input1.multiplying(by: input2)).stringValue
        case .divide:
            if input1.compare(NSDecimalNumber.zero) == ComparisonResult.orderedSame {
                return "Divide by zero"
            } else {
                return (input1.dividing(by: input2)).stringValue
            }
        }
    }
    
    static func convert(inputString: String, convertFromCurrency: String, convertToCurrency: String) -> String {
        var val1 = String()
        var val2 = String()
        var result: NSDecimalNumber?
        var currentOperator: Operator?
        
       
        
        for char in inputString {
            if let op = Operator(rawValue: String(char)) {
                currentOperator = op
                val2 = String()
                if result != nil {
                    val1 = String(result!.stringValue)
                }
                continue
                
            }
            
            if let op = currentOperator {
                val2.append(char)
                result = NSDecimalNumber(string: calculate(input1: NSDecimalNumber(string: val1), input2: NSDecimalNumber(string: val2), operation: op))
            } else {
                val1.append(char)
                result = NSDecimalNumber(string: val1)
            }
            
        }
        
        print("result = \(result?.stringValue)")
        return result?.stringValue ?? ""
    }
    
    static func onOperatorClick(op: String, inputString: String) -> String? {
        if inputString.isEmpty {
            return nil
        }
        var input = inputString
        let lastChar = inputString.last!
        if Operator(rawValue: String(lastChar)) != nil || lastChar == "." {
            input.removeLast()
        }
        input.append(op)
        return input
        
    }
    
    static func onDecimalClicked(inputString: String) -> String {
        if inputString.isEmpty {
            return "0."
        } else if inputString.last == "." {
            return ""
        } else if Operator(rawValue: String(inputString.last!)) != nil {
            return "0."
        } else if Operator.containsOperator(input: inputString){
            if getLastOperand(input: inputString).contains(".") {
                return ""
            } else {
                return "."
            }
        } else {
           if inputString.contains(".") {
                return ""
            } else {
                return "."
            }
        }
    }
    
    private static func getLastOperand(input: String) -> String {
        var operand = ""
        for char in input {
            if Operator(rawValue: String(char)) != nil {
                operand = ""
            } else {
                operand.append(char)
            }
        }
        return operand
    }
}
