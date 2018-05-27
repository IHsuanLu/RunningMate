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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.becomeFirstResponder()
        
        searchBar.delegate = self
    }
}

extension SearchVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
