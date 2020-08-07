//
//  SelectCurrencyTableViewController.swift
//  crypto
//
//  Created by Sreejith CR on 08/07/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit

class SelectCurrencyTableViewController: UITableViewController {
    
    private var currencyList = CurrencyData.cryptoCurrencies + CurrencyData.fiatCurrencies
    private var changeCurrencyDelegate: ChangeCurrencyDelegate?
    private var selectedCurrency: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    public func setValues(selectedCurrency: String, changeCurrencyDelegate: ChangeCurrencyDelegate) {
        self.selectedCurrency = selectedCurrency
        self.changeCurrencyDelegate = changeCurrencyDelegate
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currencyList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currency = currencyList[indexPath.row]
        let currencyName = "\(currency.1) (\(currency.0))"
        cell.textLabel?.text = currencyName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserData.setSelectedCurrency(currency: currencyList[indexPath.row].0)
        self.dismiss(animated: true, completion: { () in
            self.changeCurrencyDelegate?.onCurrencyChanged(selectedCurrency: self.currencyList[indexPath.row].0)
            
        })
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let currency = currencyList[indexPath.row]
        if currency.0 == selectedCurrency {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
        
        
        
    }
    
}
