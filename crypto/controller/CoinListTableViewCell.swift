//
//  CoinListTableViewCell.swift
//  crypto
//
//  Created by Sreejith CR on 27/06/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit

class CoinListTableViewCell: UITableViewCell {

    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
