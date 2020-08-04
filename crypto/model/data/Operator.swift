//
//  Operator.swift
//  crypto
//
//  Created by Sreejith CR on 18/07/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import Foundation

enum Operator: String {
    case add = "+"
    case substract = "-"
    case multiply = "*"
    case divide = "÷"
    
    static func containsOperator(input: String) -> Bool {
        return input.contains(add.rawValue) || input.contains(substract.rawValue) || input.contains(multiply.rawValue) || input.contains(divide.rawValue)
    }
    
    
}
