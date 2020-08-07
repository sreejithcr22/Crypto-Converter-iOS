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
    private var selectedLabel: UILabel!
    private var outputLabel: UILabel!
    
    private enum CurrencyButton: Int {
        case BUTTON_1  = 1
        case BUTTON_2 = 2
        
        func from(tag: Int) -> CurrencyButton {
            if tag == 1 {
                return CurrencyButton.BUTTON_1
            } else  {
                return CurrencyButton.BUTTON_2
            }
        }
    }
    
    private var currency1: String = "BTC"
    private var currency2: String = "USD"
    
    @IBAction func onDigitClicked(_ sender: UIButton) {
        if isInErrorState(label: selectedLabel) || isInErrorState(label: outputLabel) {
            return
        }
        var digit = (sender as UIButton).titleLabel?.text
        if digit == "." {
            digit = Converter.onDecimalClicked(inputString: selectedLabel.text!)
        }
        selectedLabel.text?.append(digit!)
        updateOutput()
        
    }
    @IBAction func onLabelClicked(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 1
        if tag == 1 {
            selectedLabel = value1
            outputLabel = value2
            highlightSelectedContainer(selectedView: currency1Container, unselectedView: currency2Container)
        } else {
            selectedLabel = value2
            outputLabel = value1
            highlightSelectedContainer(selectedView: currency2Container, unselectedView: currency1Container)
        }
        
    }
    
    @IBAction func onOperatorClicked(_ sender: UIButton) {
        if isInErrorState(label: selectedLabel) || isInErrorState(label: outputLabel) {
            return
        }
        let op = (sender as UIButton).titleLabel?.text
        guard let converterOutput = Converter.onOperatorClick(op: op!, inputString: selectedLabel.text!)  else {
            return
        }
        selectedLabel.text = converterOutput
        updateOutput()
    }
    
    @IBAction func onClearClicked(_ sender: UIButton) {
        selectedLabel.text = ""
        outputLabel.text = ""
    }
    
    @IBAction func onDeleteClicked(_ sender: UIButton) {
        if let currentText = selectedLabel.text {
            if !currentText.isEmpty && !isInErrorState(label: selectedLabel) {
                var val = currentText
                val.removeLast()
                selectedLabel.text = val
                if !val.isEmpty {
                    updateOutput()
                } else {
                    outputLabel.text = ""
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        setup()
        selectedLabel = value1
        outputLabel = value2
        
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
    
    private func getConvertCurrencies() -> (String, String) {
        var convertFrom: String
        var convertTo: String
        if selectedLabel == value1 {
            convertFrom = btnCurrency1.titleLabel!.text!
            convertTo = btnCurrency2.titleLabel!.text!
        } else {
            convertFrom = btnCurrency2.titleLabel!.text!
            convertTo = btnCurrency1.titleLabel!.text!
        }
        return (CurrencyData.getCurrencyCode(currencyName: convertFrom), CurrencyData.getCurrencyCode(currencyName: convertTo))
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
        highlightSelectedContainer(selectedView: currency1Container, unselectedView: currency2Container)
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
            let isSelectedCurrencyFiat = CurrencyData.isFiatCurrency(currencyCode: currency)
            var btn: UIButton
            if selectedCurrencyBtn == CurrencyButton.BUTTON_1 {
                if isSelectedCurrencyFiat && CurrencyData.isFiatCurrency(currencyCode: currency2) {
                    showFiatCurrenciesAlert()
                    return
                }
                btn = btnCurrency1
                currency1 = currency
            } else {
                if isSelectedCurrencyFiat && CurrencyData.isFiatCurrency(currencyCode: currency1) {
                    showFiatCurrenciesAlert()
                    return
                }
                btn = btnCurrency2
                currency2 = currency
            }
            
            btn.setTitle(CurrencyData.getCurrencyName(currencyCode: currency), for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { 
                if !(self.selectedLabel.text?.isEmpty ?? true) {
                    self.updateOutput()
                }
            }
            
            
        }
        
    }
    
    private func showFiatCurrenciesAlert() {
        let alert = UIAlertController(title: nil, message: "Can't convert between two fiat currencies", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    private func highlightSelectedContainer(selectedView: UIView, unselectedView: UIView) {
        selectedView.layer.borderWidth = 2
        selectedView.layer.borderColor = UIColor.green.cgColor
        unselectedView.layer.borderWidth = 0
    }
    
    private func isInErrorState(label: UILabel?) -> Bool {
        return label?.text == Converter.ERROR_STATE.DIVIDE_BY_ZERO.rawValue || label?.text == Converter.ERROR_STATE.DATA_UNAVAILABLE.rawValue
    }
    
    private func updateOutput() {
        let currencies = getConvertCurrencies()
        let output = Converter.convert(inputString: selectedLabel!.text!, convertFromCurrency: currencies.0, convertToCurrency: currencies.1)
        outputLabel.text = output
    }
}


