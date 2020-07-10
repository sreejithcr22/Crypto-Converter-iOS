//
//  APIClient.swift
//  crypto
//
//  Created by Sreejith CR on 04/07/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import Foundation
import RealmSwift

class APIClient {
    
    private enum APIConstants {
        static let SCHEME = "https"
        static let HOST = "min-api.cryptocompare.com"
        static let PATH = "/data/pricemulti"
        static let QUERY_PARAM_FSYS = "fsyms"
        static let QUERY_PARAM_TO_SYS = "tsyms"
        static let FSYS_ARG_LIMIT = 5
        static let TO_SYS_ARG_LIMIT = 5
        static let CURRENCY_TYPE_CRYPTO = 1
        static let CURRENCY_TYPE_FIAT = 2
    }
    static var sysIndexesQueue = [((Int, Int), (Int, Int), Int)]()
    
    static func syncPrices() {
        prepareForApiCall()
        executeApiCall()
    }
    
    private static func parseApiResponse(data: Data) ->List<CoinPrice>? {
        
        let decoder = JSONDecoder()
        guard let decodedVal = try? decoder.decode(Dictionary<String, Dictionary<String, Double>>.self, from: data)
            else {
                print("Failed to parse response")
                return nil
        }
        
        let result = decodedVal.map { (keyVal) -> CoinPrice in
            
            let coinPrice = CoinPrice()
            coinPrice.coinName = keyVal.key
            let prices = keyVal.value.map { (arg0) -> Price in
                let price = Price()
                price.coinName = arg0.key
                price.price.value = arg0.value
                return price
            }
            coinPrice.prices.append(objectsIn: prices)
            return coinPrice
        }
        
        
        print("API parsed result = \(result)")
        let coinPriceList = List<CoinPrice>()
        result.forEach { (coinPrice) in
            coinPriceList.append(coinPrice)
        }
        
        return coinPriceList
        
    }
    
    private static func fetchPrices(url: URL, onCompleted: @escaping () -> Void) {
        print("fetchPrices url = \(url)")
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let data = data, let coinPriceList = parseApiResponse(data: data) {
                print("API response = \(data)")
                ConverterDB.addPrices(prices: coinPriceList)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onCompleted()
            }
        })
        
        task.resume()
    }
    
    private static func constructUrl(fsys: String, toSys: String) -> URL {
        
        var components = URLComponents()
        components.scheme = APIConstants.SCHEME
        components.host = APIConstants.HOST
        components.path = APIConstants.PATH
        components.queryItems = [
            URLQueryItem(name: APIConstants.QUERY_PARAM_FSYS, value: fsys),
            URLQueryItem(name: APIConstants.QUERY_PARAM_TO_SYS, value: toSys)
        ]
        return components.url!
    }
    
    private static func executeApiCall() {
        print("executing api call")
        let systems = getFromAndToSys(fsysStart: sysIndexesQueue[0].0.0, fsysEnd: sysIndexesQueue[0].0.1,
                                      toSysStart: sysIndexesQueue[0].1.0, toSysEnd: sysIndexesQueue[0].1.1, currencyType: sysIndexesQueue[0].2)
        let fsys = systems.0
        let toSys = systems.1
        print("fsys = \(fsys) tosys = \(toSys)")
        let url = constructUrl(fsys: fsys, toSys: toSys)
        fetchPrices(url: url, onCompleted: onCurrentAPICallCompleted)
        
    }
    
    
    private static func getFromAndToSys(fsysStart: Int, fsysEnd: Int, toSysStart: Int, toSysEnd: Int, currencyType: Int) -> (String, String) {
        
        let toSysDataSource = currencyType == 1 ? CurrencyData.cryptoCurrencies : CurrencyData.fiatCurrencies
        let fsys = CurrencyData.cryptoCurrencies.enumerated().filter { (arg) -> Bool in
            return arg.offset >= fsysStart && arg.offset <= fsysEnd
        }.map { (arg) -> String in
            return arg.element.0
        }
        
        let toSys = toSysDataSource.enumerated().filter { (arg) -> Bool in
            return arg.offset >= toSysStart && arg.offset <= toSysEnd
        }.map { (arg) -> String in
            return arg.element.0
        }
        
        return (fsys.joined(separator: ","), toSys.joined(separator: ","))
        
    }
    
    private static func onCurrentAPICallCompleted() {
        print("onCurrentAPICallCompleted")
        if !sysIndexesQueue.isEmpty {
            sysIndexesQueue.removeFirst()
        }
        
        if !sysIndexesQueue.isEmpty {
            executeApiCall()
        } else {
            print("sysIndexesQueue empty, ending api calls")
        }
    }
    
    private static func prepareForApiCall() {
        
        let cryptoSize = CurrencyData.cryptoCurrencies.count
        let fiatSize = CurrencyData.fiatCurrencies.count
        
        let fsysIterator = Int((Float.init(cryptoSize)/Float.init(APIConstants.FSYS_ARG_LIMIT)).rounded(.up))
        let toSysIterator = Int((Float.init(fiatSize)/Float.init(APIConstants.TO_SYS_ARG_LIMIT)).rounded(.up))
        let toSysCryptoIterator = Int((Float.init(cryptoSize)/Float.init(APIConstants.TO_SYS_ARG_LIMIT)).rounded(.up))
        
        for i in 1...fsysIterator {
            
            let fsysStartIndex = (i * APIConstants.FSYS_ARG_LIMIT) - APIConstants.FSYS_ARG_LIMIT
            var fsysEndIndex = (i * APIConstants.FSYS_ARG_LIMIT) - 1;
            fsysEndIndex = fsysEndIndex < cryptoSize ? fsysEndIndex : cryptoSize - 1
            
            for j in 1...toSysIterator {
                
                let tosysStartIndex = (j * APIConstants.TO_SYS_ARG_LIMIT) - APIConstants.TO_SYS_ARG_LIMIT
                var tosysEndIndex = (j * APIConstants.TO_SYS_ARG_LIMIT - 1)
                tosysEndIndex = tosysEndIndex < fiatSize ? tosysEndIndex : fiatSize - 1
                sysIndexesQueue.append(((fsysStartIndex, fsysEndIndex), (tosysStartIndex, tosysEndIndex), APIConstants.CURRENCY_TYPE_FIAT))
            }
            
            for k in 1...toSysCryptoIterator {
                let start = (k * APIConstants.TO_SYS_ARG_LIMIT) - APIConstants.TO_SYS_ARG_LIMIT
                var end = (k * APIConstants.TO_SYS_ARG_LIMIT - 1);
                end = end < cryptoSize ? end : cryptoSize - 1
                sysIndexesQueue.append(((fsysStartIndex, fsysEndIndex), (start, end), APIConstants.CURRENCY_TYPE_CRYPTO))
            }
        }
    }
    
}
