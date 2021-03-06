//
//  ConverterDB.swift
//  crypto
//
//  Created by Sreejith CR on 03/07/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import Foundation
import RealmSwift

class ConverterDB {
    
    private class func getRealm() -> Realm? {
        let realm = try! Realm()
        return realm
    }
    
    class func getAllPrices() -> Results<CoinPrice>? {
        
        guard let realm = getRealm() else {
            return nil
        }
        return realm.objects(CoinPrice.self)
    }
    
    class func addPrices(prices newPrices: List<CoinPrice>) {
        
        DispatchQueue.global(qos: .background).async {
            guard let realm = getRealm() else  { return }
            let currentPrices = realm.objects(CoinPrice.self)
            realm.beginWrite()
            
            newPrices.forEach { (newPrice) in
                let currentPriceList = currentPrices.first { (currentPrice) -> Bool in
                    currentPrice.coinName == newPrice.coinName
                    }?.prices
                
                if let currentPriceList = currentPriceList {
                    newPrice.prices.forEach { (it) in
                        let existingPrice = currentPriceList.first { (currentPrice) -> Bool in
                            return currentPrice.coinName == it.coinName
                        }
                        
                        if let existingPrice = existingPrice {
                            currentPriceList.remove(at: currentPriceList.index(of: existingPrice)!)
                        }
                        currentPriceList.append(it)
                    }
                    newPrice.prices.removeAll()
                    newPrice.prices.append(objectsIn: currentPriceList)
                }
                realm.add(newPrice, update: .modified)
            }
            try! realm.commitWrite()
            
            
        }
    }
    
    class func getPriceFor(forCurrency: String, inCurrency: String) -> NSDecimalNumber? {
        guard let realm = getRealm() else {
            return nil
        }
        
        let prices = realm.object(ofType: CoinPrice.self, forPrimaryKey: forCurrency)?.prices
        let price = prices?.first(where: { (price) -> Bool in
            price.coinName == inCurrency
        })
        
        if let price = price {
            if price.price.value != nil {
                return NSDecimalNumber.init(floatLiteral: price.price.value!)
            } else {
                return nil
            }
            
        } else {
            let prices = realm.object(ofType: CoinPrice.self, forPrimaryKey: inCurrency)?.prices
            let price = prices?.first(where: { (price) -> Bool in
                price.coinName == forCurrency
            })
            
            if let priceValue = price?.price.value {
                return NSDecimalNumber.one.dividing(by: NSDecimalNumber.init(floatLiteral: priceValue))
            } else {
                return nil
            }
        }
        
    }
    
    
}
