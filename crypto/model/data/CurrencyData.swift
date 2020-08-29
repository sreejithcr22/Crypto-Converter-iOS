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
        ("LTC", "Litecoin"),
        ("XRP", "Ripple"),
        ("BCH", "Bitcoin Cash"),
        ("ADA", "Cardano"),
        ("XLM", "Stellar"),
        ("NEO", "NEO"),
        ("EOS", "EOS"),
        ("IOTA", "IOTA"),
        ("DASH", "DASH"),
        ("XEM", "NEM"),
        ("XMR", "Monero"),
        ("LSK", "LISK"),
        ("ETC", "Ethereum Classic"),
        ("VEN", "Ve Chain"),
        ("TRX", "TRON"),
        ("BTG", "Bitcoin Gold"),
        ("USDT", "Tether"),
        ("OMG", "OmiseGO"),
        ("ICX", "ICON"),
        ("ZEC", "Zcash"),
        ("XVG", "Verge"),
        ("BCN", "Bytecoin"),
        ("PPT", "Populous"),
        ("STRAT", "Stratis"),
        ("RHOC", "RChain"),
        ("SC", "Siacoin"),
        ("WAVES", "Waves"),
        ("SNT", "Status"),
        ("MKR", "Maker"),
        ("BTS", "BitShares"),
        ("VERI", "Veritaseum"),
        ("AE", "Aeternity"),
        ("WTC", "Waltonchain"),
        ("ZCL", "ZClassic"),
        ("DCR", "Decred"),
        ("REP", "Augur"),
        ("DGD", "DigixDAO"),
        ("ARDR", "Ardor"),
        ("HSR", "Hshare"),
        ("ETN", "Electroneum"),
        ("KMD", "Komodo"),
        ("GAS", "Gas"),
        ("ARK", "Ark"),
        ("BTX", "Bitcore"),
        ("VTC", "Vertcoin"),
        ("DOGE", "DogeCoin"),
        ("GNO", "GNO"),
        ("BCD", "BCD"),
        ("BAT", "BAT"),
        ("ARN", "ARN"),
        ("QTUM", "QTUM"),
        ("BIX", "BiboxCoin"),
        ("BNB", "BinanceCoin"),
        ("XUC", "Exchange Union"),
        ("HT", "Huobi Token"),
        ("QKC", "QuarkChain"),
        ("ZIL", "Zilliqa"),
        ("NANO", "NANO"),
        ("MITH", "Mithril"),
        ("IOST", "IOS Token"),
        ("QASH", "Quoine Liquid"),
        ("NAS", "Nebulas"),
        ("POWR", "Power Ledger"),
        ("IOTX", "IoTeX Network"),
        ("CVC", "Civic"),
        ("RDD", "Reddcoin"),
        ("OCN", "Odyssey"),
        ("ELF", "aelf"),
        ("CTXC", "Cortex"),
        ("STEEM", "Steem"),
        ("KNC", "Kyber Network"),
        ("SALT", "Salt Lending"),
        ("GTO", "GIFTO"),
        ("BLZ", "Bluezelle"),
        ("UBTC", "UnitedBitcoin"),
        ("XZC", "ZCoin"),
        ("GVT", "Genesis Vision"),
        ("NULS", "Nuls"),
        ("BOX", "ContentBox"),
        ("XIN", "Infinity Economics"),
        ("APIS", "APIS"),
        ("BMX", "Bitmart Coin"),
        ("PST", "Primas"),
        ("SWFTC", "SwftCoin"),
        ("WPR", "WePower"),
        ("VIBE", "VOIBEHub"),
        ("LYM", "Lympo"),
        ("EVX", "Everex"),
        ("VET", "Vechain"),
        ("VIB", "Viberate"),
        ("MDA", "Moeda"),
        ("ONT", "Ontology"),
        ("OKB", "Okex"),
        ("ETF", "EthereumFog"),
        ("LINK", "Chainlink"),
        ("BSV", "Bitcoin SV"),
        ("XTZ", "Tezos"),
        
    ]
    static let fiatCurrencies = [
        
        ("USD","US Dollar"),
        ("INR","Indian Rupee"),
        ("EUR","EURO"),
        ("GBP","Pound"),
        ("CNY", "Chinese Yuan"),
        ("AUD", "Australian Dollar"),
        ("CAD", "Canadian Dollar"),
        ("JPY", "Japanese Yen"),
        ("RUR", "Russian ruble"),
        ("PLN", "Poland złoty"),
        ("SGD", "Singapore Dollar"),
        ("HKD", "Hong Kong Dollar"),
        ("ZAR", "South African Rand"),
        ("KRW", "South Korean won"),
        ("NZD", "New Zealand Dollar"),
        ("SEK", "Swedish Krona"),
        ("UAH", "Ukrainian hryvnia"),
        ("ILS", "Israeli New Shekel"),
        ("THB", "Thai Baht"),
        ("VND", "Vietnamese dong"),
        ("DKK", "Danish Krone"),
        ("MXN", "Mexican Peso"),
        ("CZK", "Czech Koruna"),
        ("CLP", "Chilean Peso"),
        ("TRY", "Turkish lira"),
        ("NGN", "Nigerian Naira"),
        ("IDR", "Indonesian Rupiah"),
        ("MYR", "Malaysian Ringgit"),
        ("PHP", "Philippine Piso"),
        ("ARS", "Argentine Peso"),
        ("IRR", "Iranian Rial"),
        ("UGX", "Ugandan Shilling"),
        ("BHD", "Bahraini Dinar"),
        ("COP", "Colombian Peso"),
        ("RON", "Romanian Leu"),
        ("BGN", "Bulgarian Lev"),
        ("PKR", "Pakistani Rupee"),
        ("NOK", "Norwegian Krone"),
        ("JOD", "Jordanian Dinar"),
        ("BRL", "Brazilian real"),
        ("VEF", "Venezuelan bolívar"),
        ("AED", "United Arab Emirates Dirham"),
        
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
