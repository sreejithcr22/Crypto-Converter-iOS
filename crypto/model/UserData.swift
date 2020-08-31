//
//  UserData.swift
//  crypto
//
//  Created by Sreejith CR on 09/07/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import Foundation

struct UserData {
    private static var SELECTED_CURRENCY = "selected_currency"
    
    public static func getSelectedCurrency() ->String {
        return UserDefaults.standard.string(forKey: SELECTED_CURRENCY) ?? "USD"
    }
    public static func setSelectedCurrency(currency: String) {
        UserDefaults.standard.set(currency, forKey: SELECTED_CURRENCY)
    }
    public static let AD_ID = "ca-app-pub-7040172378865675/1562787166"
}
