//
//  ViewController.swift
//  crypto
//
//  Created by Sreejith CR on 25/05/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ChangeCurrencyDelegate {
    
    @IBOutlet weak var buttonsContainerStack: UIStackView!
    @IBOutlet weak var currency1Container: UIView!
    @IBOutlet weak var currency2Container: UIView!
    @IBOutlet weak var value1: UILabel!
    @IBOutlet weak var value2: UILabel!
    
    @IBOutlet weak var btnCurrency1: UIButton!
    @IBOutlet weak var btnCurrency2: UIButton!
    private var selectedCurrencyBtn: CurrencyButton = .BUTTON_1
    
    private enum CurrencyButton: Int {
        case BUTTON_1  = 1
        case BUTTON_2 = 2
    }
    
    private var currency1: String = "BTC"
    private var currency2: String = "USD"
    
    @IBAction func onDigitClicked(_ sender: UIButton) {
        print((sender as UIButton).titleLabel?.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        setup()
    }
    
    private func drawUI() {
        
        applyElevation(view: currency1Container)
        applyElevation(view: currency2Container)
        
        applyBorder(view: btnCurrency1)
        applyBorder(view: btnCurrency2)
        
        buttonsContainerStack.subviews.forEach { (view) in
            view.subviews.forEach { (button) in
                applyBorder(view: button)
            }
        }
    }
    
    
    private func applyBorder(view: UIView) {
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 0.25
    }
    
    private func applyElevation(view: UIView) {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.25, height: 0.25)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 2.0
        view.layer.cornerRadius = 5
    }
    
    
    private func setup() {
        btnCurrency1.setTitle(CurrencyData.getCurrencyName(currencyCode: currency1), for: .normal)
        btnCurrency2.setTitle(CurrencyData.getCurrencyName(currencyCode: currency2), for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var selectedCurrency: String? = nil
        if segue.identifier == "currency1" {
            selectedCurrency = currency1
            selectedCurrencyBtn = CurrencyButton.BUTTON_1
        } else if segue.identifier == "currency2" {
            selectedCurrency = currency2
            selectedCurrencyBtn = CurrencyButton.BUTTON_2
        }
        if let selectedCurrency = selectedCurrency {
            let viewController = segue.destination as? SelectCurrencyTableViewController
            viewController?.setValues(selectedCurrency: selectedCurrency, changeCurrencyDelegate: self)
        }
    }
    
    func onCurrencyChanged(selectedCurrency: String?) {
        if let currency = selectedCurrency {
            var btn: UIButton
            if selectedCurrencyBtn == CurrencyButton.BUTTON_1 {
                btn = btnCurrency1
                currency1 = currency
            } else {
                btn = btnCurrency2
                currency2 = currency
            }
            btn.setTitle(CurrencyData.getCurrencyName(currencyCode: currency), for: .normal)
        }
        
    }
    
   
    
}
   

