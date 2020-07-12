//
//  CoinListTableViewController.swift
//  crypto
//
//  Created by Sreejith CR on 27/06/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit
import RealmSwift

class CoinListTableViewController: UITableViewController, ChangeCurrencyDelegate {
    
    @IBOutlet weak var changeCurrencyBtn: UIButton!
    private var coinPrices: Results<CoinPrice>?
    private var selectedCurrency = UserData.getSelectedCurrency()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinPrices = ConverterDB.getAllPrices()
        changeCurrencyBtn.setTitle(selectedCurrency, for: .normal)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinPrices?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinListTableViewCell", for: indexPath) as? CoinListTableViewCell
        
        if let coinPrice = self.coinPrices?[indexPath.row] {
            
            cell?.coinName.text = coinPrice.coinName
            let priceDouble = coinPrice.prices.first(where: { (price) -> Bool in
                price.coinName == selectedCurrency
            })?.price.value ?? -1
            let priceString: String = priceDouble.isEqual(to: -1) ? "NA" : String(format:"%.2f", priceDouble)
            cell?.coinPrice.text = priceString
        }
        
        return cell!
    }
    
 
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectCurrencySegue" {
            let viewController = segue.destination as! SelectCurrencyTableViewController
            viewController.setValues(selectedCurrency: UserData.getSelectedCurrency(), changeCurrencyDelegate: self)
            
        }
     }
    
  
    
    func onCurrencyChanged(selectedCurrency: String?) {
        self.selectedCurrency = UserData.getSelectedCurrency()
        changeCurrencyBtn.setTitle(selectedCurrency, for: .normal)
        print("currency changed = \(selectedCurrency)")
        self.tableView.reloadData()
    }
    
    
}
