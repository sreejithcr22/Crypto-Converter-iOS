//
//  FavPairDB.swift
//  crypto
//
//  Created by Sreejith CR on 09/08/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import Foundation
import RealmSwift

class FavPairDB {
    
    private class func getRealm() -> Realm? {
        let realm = try! Realm()
        return realm
    }
    
    class func getFavouritePairs() -> Array<FavPair>? {
        guard let realm = getRealm() else {
            return nil
        }
        return Array(realm.objects(FavPair.self))
    }
    
    class func addPair(convertFrom: String, convertTo: String) {
        DispatchQueue.global(qos: .background).async {
            if !isPairAdded(convertFrom: convertFrom, convertTo: convertTo) {
                guard let realm = getRealm() else  { return }
                let pair = FavPair()
                pair.convertFrom = convertFrom
                pair.convertTo = convertTo
                realm.beginWrite()
                realm.add(pair)
                try! realm.commitWrite()
            }
        }
    }
    
    class func isPairAdded(convertFrom: String, convertTo: String) -> Bool {
        guard let realm = getRealm() else {
            return false
        }
        let pairs = realm.objects(FavPair.self)
        return pairs.first { (pair) -> Bool in
            return (pair.convertFrom == convertFrom && pair.convertTo == convertTo) || (pair.convertTo == convertFrom && pair.convertFrom == convertTo)
            } != nil
    }
    
    class func deletePair(convertFrom: String, convertTo: String) {
        guard let realm = getRealm() else {
            return
        }
        let object = realm.objects(FavPair.self).first { (pair) -> Bool in
            return (pair.convertFrom == convertFrom && pair.convertTo == convertTo) || (pair.convertTo == convertFrom && pair.convertFrom == convertTo)
        }
        
        if let objectToDelete = object {
            realm.beginWrite()
            realm.delete(objectToDelete)
            try! realm.commitWrite()
        }
    }
}

