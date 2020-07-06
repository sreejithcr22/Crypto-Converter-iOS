//
//  CoinListTableViewController.swift
//  crypto
//
//  Created by Sreejith CR on 27/06/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit
import RealmSwift

class CoinListTableViewController: UITableViewController {
    
    
    private var coinPrices: Results<CoinPrice>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinPrices = ConverterDB.getAllPrices()
        print("coin prices db = \(coinPrices)")
        
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
                price.coinName == "USD"
            })?.price.value ?? -1
            let priceString: String = priceDouble.isEqual(to: -1) ? "NA" : String(format:"%.2f", priceDouble)
            cell?.coinPrice.text = priceString
        }
        
        
        
        
        // Configure the cell...
        
        return cell!
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
