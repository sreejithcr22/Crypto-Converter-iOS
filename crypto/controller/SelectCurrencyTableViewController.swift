//
//  SelectCurrencyTableViewController.swift
//  crypto
//
//  Created by Sreejith CR on 08/07/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit

class SelectCurrencyTableViewController: UITableViewController, UISearchResultsUpdating {
    
    private var currencyList = CurrencyData.cryptoCurrencies + CurrencyData.fiatCurrencies
    private var filteredList: [(String, String)] = []
    private var changeCurrencyDelegate: ChangeCurrencyDelegate?
    private var selectedCurrency: String? = nil
    private var resultSearchController = UISearchController()
    private var shouldUpdateCurrencyToUserData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        self.tableView.tableFooterView = UIView()
    }
    
    public func setValues(selectedCurrency: String, changeCurrencyDelegate: ChangeCurrencyDelegate, shouldUpdateCurrencyToUserData: Bool) {
        self.selectedCurrency = selectedCurrency
        self.changeCurrencyDelegate = changeCurrencyDelegate
        self.shouldUpdateCurrencyToUserData = shouldUpdateCurrencyToUserData
    }
    
    private func setupSearchBar() {
        self.resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.obscuresBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController.searchBar
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive {
            return filteredList.count
        } else {
            return currencyList.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var list = currencyList
        if resultSearchController.isActive {
            list = filteredList
        }
        let currency = list[indexPath.row]
        let currencyName = "\(currency.1) (\(currency.0))"
        cell.textLabel?.text = currencyName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var list = currencyList
        if resultSearchController.isActive {
            list = filteredList
        }
        if shouldUpdateCurrencyToUserData {
            UserData.setSelectedCurrency(currency: list[indexPath.row].0)
        }
        resultSearchController.dismiss(animated: false, completion: nil)
        self.dismiss(animated: true, completion: { () in
            self.changeCurrencyDelegate?.onCurrencyChanged(selectedCurrency: list[indexPath.row].0)
            
        })
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let currency = currencyList[indexPath.row]
        if currency.0 == selectedCurrency {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredList.removeAll(keepingCapacity: false)
            if searchText.isEmpty {
                filteredList.append(contentsOf: currencyList)
            } else {
                let items = currencyList.filter { (arg0) -> Bool in
                    return arg0.0.lowercased().contains(searchText.lowercased()) || arg0.1.lowercased().contains(searchText.lowercased())
                }
                filteredList.append(contentsOf: items)
            }
            self.tableView.reloadData()
        }
    }
    
    
    
}
