//
//  FavPair.swift
//  crypto
//
//  Created by Sreejith CR on 09/08/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import Foundation
import RealmSwift

class FavPair: Object {
    @objc dynamic var convertFrom: String?
    @objc dynamic var convertTo: String?
}
