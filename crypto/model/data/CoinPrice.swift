//
//  CoinPrices.swift
//  crypto
//
//  Created by Sreejith CR on 02/07/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import Foundation
import RealmSwift

class CoinPrice: Object {
    
    @objc dynamic var coinName: String?
    let prices = List<Price>()
    
   override static func primaryKey() -> String? {
        return "coinName"
    }
    
}

