//
//  Price.swift
//  crypto
//
//  Created by Sreejith CR on 03/07/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import Foundation
import RealmSwift

class Price: Object {
    @objc dynamic var coinName: String?
    let price = RealmOptional<Double>()
    
}
