//
//  Converter.swift
//  crypto
//
//  Created by Sreejith CR on 18/07/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import Foundation

struct Converter {
    
    enum DIGITS: String {
        case DECIMAL = "."
        case ZERO_DECIMAL = "0."
    }
    
    enum ERROR_STATE: String {
        //TODO: localisation
        case DIVIDE_BY_ZERO = "Can't divide by zero"
        case DATA_UNAVAILABLE = "Data not available"
    }
    private static func calculate(input1: NSDecimalNumber, input2: NSDecimalNumber, operation: Operator) -> String?  {
        
        switch operation {
        case .add : return (input1.adding(input2)).stringValue
        case .substract: return (input1.subtracting(input2)).stringValue
        case .multiply: return (input1.multiplying(by: input2)).stringValue
        case .divide:
            if input2.compare(NSDecimalNumber.zero) == ComparisonResult.orderedSame {
                return nil
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
                if let output = calculate(input1: NSDecimalNumber(string: val1), input2: NSDecimalNumber(string: val2), operation: op) {
                    result = NSDecimalNumber(string: output)
                } else {
                    return ERROR_STATE.DIVIDE_BY_ZERO.rawValue
                }
            } else {
                val1.append(char)
                result = NSDecimalNumber(string: val1)
            }
            
        }
        
        if let result = result, let converterOutput = convertCurrency(from: convertFromCurrency, to: convertToCurrency, value: result) {
            return converterOutput
        } else {
            return ERROR_STATE.DATA_UNAVAILABLE.rawValue
        }
        
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
            return DIGITS.ZERO_DECIMAL.rawValue
        } else if inputString.last == "." {
            return ""
        } else if Operator(rawValue: String(inputString.last!)) != nil {
            return DIGITS.ZERO_DECIMAL.rawValue
        } else if Operator.containsOperator(input: inputString){
            if getLastOperand(input: inputString).contains(DIGITS.DECIMAL.rawValue) {
                return ""
            } else {
                return DIGITS.DECIMAL.rawValue
            }
        } else {
            if inputString.contains(DIGITS.DECIMAL.rawValue) {
                return ""
            } else {
                return DIGITS.DECIMAL.rawValue
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
    
    private static func convertCurrency(from: String, to: String, value: NSDecimalNumber) -> String? {
        let price = ConverterDB.getPriceFor(forCurrency: from, inCurrency: to)
        if let price = price {
            print("from = \(from) to = \(to) price = \(price)")
            let result = value.multiplying(by: price)
            let handler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.bankers, scale: 8, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            return result.rounding(accordingToBehavior: handler).stringValue
            
        } else {
            return nil
        }
    }
}
