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
    
    class func addPrices(prices: List<CoinPrice>) {
        
        DispatchQueue.global(qos: .background).async {
            guard let realm = getRealm() else  { return }
            realm.beginWrite()
            prices.forEach { (price) in
                realm.add(price, update: .modified)
            }
            try! realm.commitWrite()
        
    
        }
    }
    
    
}
