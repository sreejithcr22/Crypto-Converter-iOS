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
     private static var SESSION_COUNT = "session_count"
    
    public static func getSelectedCurrency() ->String {
        return UserDefaults.standard.string(forKey: SELECTED_CURRENCY) ?? "USD"
    }
    public static func setSelectedCurrency(currency: String) {
        UserDefaults.standard.set(currency, forKey: SELECTED_CURRENCY)
    }
    public static func updateSessionCount() {
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: SESSION_COUNT)+1, forKey: SESSION_COUNT)
    }
    public static func shouldShowAd() -> Bool {
        return UserDefaults.standard.integer(forKey: SESSION_COUNT) > 2
    }
    public static let AD_ID = "ca-app-pub-3940256099942544/1033173712"
    
}
