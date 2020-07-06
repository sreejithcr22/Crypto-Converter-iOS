//
//  ViewController.swift
//  crypto
//
//  Created by Sreejith CR on 25/05/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBAction func onClicked(_ sender: UIButton) {
        valueLabel.text = sender.titleLabel?.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

