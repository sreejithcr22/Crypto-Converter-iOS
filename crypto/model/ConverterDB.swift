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
    
    
}
