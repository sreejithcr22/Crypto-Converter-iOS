//
//  ViewController.swift
//  crypto
//
//  Created by Sreejith CR on 25/05/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ChangeCurrencyDelegate, FavouritesDelegate, PriceFetchProgressDelegate {
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet weak var loadingView: UIStackView!
    @IBOutlet weak var rootView: UIStackView!
    @IBOutlet weak var buttonsContainerStack: UIStackView!
    @IBOutlet weak var currency1Container: UIView!
    @IBOutlet weak var currency2Container: UIView!
    @IBOutlet weak var value1: UILabel!
    @IBOutlet weak var value2: UILabel!
    @IBOutlet weak var addFavButton: UIButton!
    
    @IBOutlet weak var btnCurrency1: UIButton!
    @IBOutlet weak var btnCurrency2: UIButton!
    private var selectedCurrencyBtn: CurrencyButton = .BUTTON_1
    private var selectedLabel: UILabel!
    private var outputLabel: UILabel!
    private let PROGRESS_SHOWN = "progress_shown"
    
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
    
    @IBAction func onEqualClicked(_ sender: Any) {
        if selectedLabel.text?.isEmpty ?? true || isInErrorState(label: selectedLabel) || isInErrorState(label: outputLabel) {
            return
        }
        let currencies = getConvertCurrencies()
        let output = Converter.convert(inputString: selectedLabel!.text!, convertFromCurrency: currencies.0, convertToCurrency: currencies.1)
        outputLabel.text = output.0
        selectedLabel.text = output.1
    }
    
    @IBAction func onFavButtonClicked(_ sender: UIButton) {
        let currencies = getConvertCurrencies()
        if sender.tag == 0 {
            sender.tintColor = UIColor.red
            sender.tag = 1
            FavPairDB.addPair(convertFrom: currencies.0, convertTo: currencies.1)
            showAlertWith(message: "Added to favourites")
        } else {
            sender.tintColor = UIColor.darkGray
            sender.tag = 0
            FavPairDB.deletePair(convertFrom: currencies.0, convertTo: currencies.1)
            showAlertWith(message: "Removed from favourites")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if Utils.isConnectedToNetwork() {
            APIClient.syncPrices(progressDelegate: self)
        } else {
            showAlertWith(message: "Please connect to the internet and relaunch the app.", title: "No network")
        }
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
        updateFavPairStatus()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var selectedCurrency: String? = nil
        if segue.identifier == "currency1" {
            selectedCurrency = currency1
            selectedCurrencyBtn = CurrencyButton.BUTTON_1
        } else if segue.identifier == "currency2" {
            selectedCurrency = currency2
            selectedCurrencyBtn = CurrencyButton.BUTTON_2
        } else if segue.identifier == "Favourites" {
            let navigationController = segue.destination as? UINavigationController
            let viewController = navigationController?.viewControllers.first as? FavouritesListViewController
            viewController?.delegate = self
            return
        }
        if let selectedCurrency = selectedCurrency {
            let navigationController = segue.destination as? UINavigationController
            let viewController = navigationController?.viewControllers.first as? SelectCurrencyTableViewController
            viewController?.setValues(selectedCurrency: selectedCurrency, changeCurrencyDelegate: self, shouldUpdateCurrencyToUserData: false)
        }
    }
    
    func onCurrencyChanged(selectedCurrency: String?) {
        if let currency = selectedCurrency {
            let isSelectedCurrencyFiat = CurrencyData.isFiatCurrency(currencyCode: currency)
            var btn: UIButton
            if selectedCurrencyBtn == CurrencyButton.BUTTON_1 {
                if isSelectedCurrencyFiat && CurrencyData.isFiatCurrency(currencyCode: currency2) {
                    showAlertWith(message: "Can't convert between two fiat currencies")
                    return
                }
                btn = btnCurrency1
                currency1 = currency
            } else {
                if isSelectedCurrencyFiat && CurrencyData.isFiatCurrency(currencyCode: currency1) {
                    showAlertWith(message: "Can't convert between two fiat currencies")
                    return
                }
                btn = btnCurrency2
                currency2 = currency
            }
            
            btn.setTitle(CurrencyData.getCurrencyName(currencyCode: currency), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.updateFavPairStatus()
                if !(self.selectedLabel.text?.isEmpty ?? true) {
                    self.updateOutput()
                }
            }
            
            
        }
        
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
        outputLabel.text = output.0
    }
    
    private func updateFavPairStatus() {
        let currencies = getConvertCurrencies()
        let isFav = FavPairDB.isPairAdded(convertFrom: currencies.0, convertTo: currencies.1)
        addFavButton.tintColor = isFav ? UIColor.red : UIColor.darkGray
        addFavButton.tag = isFav ? 1 : 0
        
    }
    
    func onFavouriteSelected(favPair: FavPair) {
        btnCurrency1.setTitle(CurrencyData.getCurrencyName(currencyCode: favPair.convertFrom!), for: .normal)
        btnCurrency2.setTitle(CurrencyData.getCurrencyName(currencyCode: favPair.convertTo!), for: .normal)
        addFavButton.tintColor = UIColor.red
        addFavButton.tag = 1
        value1.text = ""
        value2.text = ""
        currency1 = favPair.convertFrom!
        currency2 = favPair.convertTo!
    }
    
    func updateProgress(progress: Int) {
        if isProgressShown() {
            return
        }
        if progress == 100 {
            UserDefaults.standard.set(true, forKey: PROGRESS_SHOWN)
            rootView.isHidden = false
            loadingView.isHidden = true
        } else {
            rootView.isHidden = true
            loadingView.isHidden = false
            loadingLabel.text = "Downloading prices[\(progress)%]..."
        }
    }
    
    private func isProgressShown() -> Bool {
        return UserDefaults.standard.bool(forKey: PROGRESS_SHOWN)
    }

}

extension UIViewController {
    
    func showAlertWith(message: String) {
           let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true)
       }
    
    func showAlertWith(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

