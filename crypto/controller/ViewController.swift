//
//  ViewController.swift
//  crypto
//
//  Created by Sreejith CR on 25/05/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ChangeCurrencyDelegate {
    
    @IBOutlet weak var value1: UILabel!
    @IBOutlet weak var value2: UILabel!
    
    private var currency1: String = "BTC"
    private var currency2: String = "USD"
    
    @IBAction func onClicked(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var selectedCurrency: String? = nil
        if segue.identifier == "currency1" {
            selectedCurrency = currency1
        } else if segue.identifier == "currency2" {
            selectedCurrency = currency2
        }
        if let selectedCurrency = selectedCurrency {
            let viewController = segue.destination as? SelectCurrencyTableViewController
            viewController?.setValues(selectedCurrency: selectedCurrency, changeCurrencyDelegate: self)
        }
    }
    
    func onCurrencyChanged() {
        
    }


}

