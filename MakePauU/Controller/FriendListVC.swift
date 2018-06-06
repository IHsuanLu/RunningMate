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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    var sections = [
        FriendListSection(section: "摯友", thumbnailImages: [], titles: [], metTimes: []),
        FriendListSection(section: "普通朋友", thumbnailImages: [], titles: [], metTimes: [])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        

        
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let tableView = tableView {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        FirebaseService.shared().getFriendList { (friendLists) in
//
//            for friendList in friendLists {
//                if friendList.ifFavorite == true && friendList.ifAdded == false {
//                    self.sections[0].titles.append(friendList.title)
//                    self.sections[0].thumbnailImages.append(friendList.thumbImage)
//                    self.sections[0].metTimes.append(friendList.metTimes)
//                } else if friendList.ifFavorite == false {
//                    self.sections[1].titles.append(friendList.title)
//                    self.sections[1].thumbnailImages.append(friendList.thumbImage)
//                    self.sections[1].metTimes.append(friendList.metTimes)
//                }
//            }
//
//            print("---------------\(self.sections[0].titles)")
//        }
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
    
    
    @IBAction func backFromSearch_Enter(segue: UIStoryboardSegue) {
        
        self.tabBarController?.selectedIndex = 2
        
        guard let searchVC = segue.source as? SearchVC else { return }
        
        self.searchBar.text = searchVC.searchBar.text
    }
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        showchatController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSearchVC"{
            _ = segue.destination as! SearchVC
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    //出現聊天頁面
    func showchatController() {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}

extension FriendListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].titles.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var titles = ["摯友", "普通朋友"]
        var images = [#imageLiteral(resourceName: "star"), #imageLiteral(resourceName: "friend")]
        
        let view = UIView()
        view.backgroundColor = UIColor(netHex: 0xFFFFFF)
        view.frame.size = CGSize(width: 375, height: 30)
        
        let image = UIImageView(image: images[section])
        image.frame = CGRect(x: 15, y: 22, width: 20, height: 20)
        
        let label = UILabel()
        label.text = titles[section]
        label.textColor = UIColor(netHex: 0x7F7F7F)
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        label.frame = CGRect(x: 40, y: 22, width: 300, height: 25)
        
        view.addSubview(label)
        view.addSubview(image)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListCell

        let titles = self.sections[indexPath.section].titles
        let title = titles![indexPath.row]
        
        let thumbnailImages = self.sections[indexPath.section].thumbnailImages
        let thumbnailImage = thumbnailImages![indexPath.row]
        
        let metTimes = self.sections[indexPath.section].metTimes
        let metTime = metTimes![indexPath.row]
        
        cell.nameLbl.text = title
        cell.profileImageView.image = thumbnailImage
        cell.metTimesLbl.text = "遇到次數：\(metTime)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
