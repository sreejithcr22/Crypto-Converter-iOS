//
//  CoinListTableViewController.swift
//  crypto
//
//  Created by Sreejith CR on 27/06/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class CoinListTableViewController: UITableViewController, ChangeCurrencyDelegate,  UISearchResultsUpdating {
    
    @IBOutlet weak var changeCurrencyBtn: UIButton!
    private var coinPrices: Array<CoinPrice>?
    private var filteredList: Array<CoinPrice>?
    private var selectedCurrency = UserData.getSelectedCurrency()
    private var resultSearchController = UISearchController()
    private var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = GADInterstitial(adUnitID: UserData.AD_ID)
        let request = GADRequest()
        interstitial.delegate = self
        interstitial.load(request)
        
        setupSearchBar()
        self.tableView.allowsSelection = false
        if let prices = ConverterDB.getAllPrices() {
            coinPrices = Array(prices)
        } else {
            coinPrices = Array()
        }
        sortCurrencyList()
        changeCurrencyBtn.setTitle(selectedCurrency, for: .normal)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            return filteredList?.count ?? 0
        } else {
            return coinPrices?.count ?? 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinListTableViewCell", for: indexPath) as? CoinListTableViewCell
        var list = coinPrices
        self.tableView.tableFooterView = UIView()
        if resultSearchController.isActive {
            list = filteredList
        }
        
        if let coinPrice = list?[indexPath.row] {
            
            cell?.coinName.text = CurrencyData.getCurrencyName(currencyCode: coinPrice.coinName!)
            let priceDouble = coinPrice.prices.first(where: { (price) -> Bool in
                price.coinName == selectedCurrency
            })?.price.value ?? -1
            let priceString: String = priceDouble.isEqual(to: -1) ? "NA" : String(format:"%.2f", priceDouble)
            cell?.coinPrice.text = "\(selectedCurrency.uppercased()) \(priceString)"
        }
        
        return cell!
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectCurrencySegue" {
            let navigationController = segue.destination as? UINavigationController
            let viewController = navigationController?.viewControllers.first as? SelectCurrencyTableViewController
            viewController?.setValues(selectedCurrency: UserData.getSelectedCurrency(), changeCurrencyDelegate: self, shouldUpdateCurrencyToUserData: true)
            
        }
    }
    
    func onCurrencyChanged(selectedCurrency: String?) {
        self.selectedCurrency = UserData.getSelectedCurrency()
        changeCurrencyBtn.setTitle(selectedCurrency, for: .normal)
        print("currency changed = \(selectedCurrency)")
        sortCurrencyList()
        self.tableView.reloadData()
    }
    
    private func setupSearchBar() {
        self.resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.obscuresBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController.searchBar
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty {
                filteredList = coinPrices
            } else {
                filteredList = coinPrices?.filter({ (price) -> Bool in
                    let coinFullName = CurrencyData.getCurrencyName(currencyCode: price.coinName!)
                    return (price.coinName?.lowercased().contains(searchText.lowercased()) ?? false || coinFullName.lowercased().contains(searchText.lowercased()))
                })
            }
            self.tableView.reloadData()
        }
    }
    
    private func sortCurrencyList() {
        coinPrices?.sort(by: { (coinPrice1, coinPrice2) -> Bool in
            let priceDouble1 = coinPrice1.prices.first(where: { (price) -> Bool in
                price.coinName == selectedCurrency
            })?.price.value ?? -1
            
            let priceDouble2 = coinPrice2.prices.first(where: { (price) -> Bool in
                price.coinName == selectedCurrency
            })?.price.value ?? -1
            
            return priceDouble1 > priceDouble2
        })
    }
    
}

extension CoinListTableViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if(ad.isReady) {
            ad.present(fromRootViewController: self)
        }
    }

}
