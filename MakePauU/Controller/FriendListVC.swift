//
//  FriendListVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/16.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class FriendListVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.performSegue(withIdentifier: "toSearchVC", sender: nil)
        
        searchBar.endEditing(true)
        searchBar.reloadInputViews()
    }
    
    @IBAction func backFromSearch(segue: UIStoryboardSegue) {
        
        self.tabBarController?.selectedIndex = 2
        print("We are back")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSearchVC"{
            _ = segue.destination as! SearchVC
        }
    }
}
