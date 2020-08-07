//
//  CurrencyData.swift
//  crypto
//
//  Created by Sreejith CR on 05/07/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import Foundation

struct CurrencyData {
    
    static let cryptoCurrencies = [
        ("BTC","Bitcoin"),
        ("ETH","Ethereum"),
        ("LTC", "Litecoin")
    ]
    static let fiatCurrencies = [
        ("USD","US dollars"),
        ("EUR","EUR"),
        ("INR","Indian rupees"),
        ("GBP","Pound"),
        ("KWD", "Kuwait dinar")
    ]
    
    static func getCurrencyName(currencyCode: String) -> String {
        var currency = cryptoCurrencies.first(where: { (arg0) -> Bool in
            return arg0.0 == currencyCode
        })
        
        if currency == nil {
            currency = fiatCurrencies.first(where: { (arg0) -> Bool in
                return arg0.0 == currencyCode
            })
        }
        
        if currency != nil {
            return "\(currency!.1) (\(currency!.0))"
        } else {
            return ""
        }
        
        
    }
    
    static func getCurrencyCode(currencyName: String) -> String {
        var currency = currencyName
        currency.removeLast()
        return String(currency.split(separator: "(")[1])
    }
    
    static func isFiatCurrency(currencyCode: String) -> Bool {
        return fiatCurrencies.first { (arg0) -> Bool in
            arg0.0 == currencyCode
        } != nil
    }
}
