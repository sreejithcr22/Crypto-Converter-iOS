//
//  FavouritesListViewController.swift
//  crypto
//
//  Created by Sreejith CR on 09/08/20.
//  Copyright © 2020 Sreejith CR. All rights reserved.
//

import UIKit

class FavouritesListViewController: UITableViewController {
    private var favList: Array<FavPair>? = nil
    var delegate: FavouritesDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        favList = FavPairDB.getFavouritePairs()
        if favList?.isEmpty ?? true {
            showFavsEmpty()
        }
        self.tableView.reloadData()
     
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favList?.count ?? 0
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let pair = favList?[indexPath.row] {
            cell.textLabel?.text = "\(pair.convertFrom ?? "")  <->  \(pair.convertTo ?? "")"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pair = favList?[indexPath.row] {
            self.dismiss(animated: true, completion: { () in
                self.delegate?.onFavouriteSelected(favPair: pair)
            })
        }
    }
   
    private func showFavsEmpty() {
        let alert = UIAlertController(title: nil, message: "Favourites list is empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true)
        
    }

}
