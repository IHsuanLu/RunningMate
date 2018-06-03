//
//  SearchVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/18.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchHistory: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchHistory = ["死亡少女", "我剛剛跨完年", "醜醜阿臻", "洗廁所一哥", "拿鐵好喝"]
        
        self.searchBar.becomeFirstResponder()
        
        searchBar.delegate = self
        
        tableView.tableFooterView = UIView()
    }
}

extension SearchVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        cell.title.text = searchHistory[indexPath.row]
        
        return cell
    }
}
