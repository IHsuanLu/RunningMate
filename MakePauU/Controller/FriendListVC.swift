//
//  FriendListVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/16.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class FriendListVC: UIViewController {
    
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
    
    lazy var statVC: StatVC = {
        let sv = StatVC()
        sv.friendListVC = self
        return sv
    }()
    
    var sections = [
        FriendListSection(section: "摯友", thumbnailImages: [], titles: [], metTimes: []),
        FriendListSection(section: "普通朋友", thumbnailImages: [], titles: [], metTimes: [])
    ]
    
    var filteredSections = [
        FriendListSection(section: "摯友", thumbnailImages: [], titles: [], metTimes: []),
        FriendListSection(section: "普通朋友", thumbnailImages: [], titles: [], metTimes: [])
    ]
    
    var filteredNormalFriends: [FriendList]!
    var filteredFavoriteFriends: [FriendList]!

    var normalFriends: [FriendList]!
    var favoriteFriends: [FriendList]!
    
    var whetherInSearchMode:Bool = false //by default

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sections = [
            FriendListSection(section: "摯友", thumbnailImages: [], titles: [], metTimes: []),
            FriendListSection(section: "普通朋友", thumbnailImages: [], titles: [], metTimes: [])
        ]

        //setFirendList
        FirebaseService.shared().setFriendList { (normalFriends, favoriteFriends) in

            self.normalFriends = normalFriends
            self.favoriteFriends = favoriteFriends

            for obj in normalFriends {
                self.sections[1].titles.append(obj.title)
                self.sections[1].thumbnailImages.append(obj.thumbImage)
                self.sections[1].metTimes.append(obj.metTimes)
            }

            for obj in favoriteFriends {
                self.sections[0].titles.append(obj.title)
                self.sections[0].thumbnailImages.append(obj.thumbImage)
                self.sections[0].metTimes.append(obj.metTimes)
            }
        }
    }
    
    @IBAction func backFromSearch(segue: UIStoryboardSegue) {
        
        self.tabBarController?.selectedIndex = 2
        
        detectChanges()
    }
    
    
    @IBAction func backFromSearch_Enter(segue: UIStoryboardSegue) {
        
        self.tabBarController?.selectedIndex = 2
        guard let searchVC = segue.source as? SearchVC else { return }
        
        self.searchBar.text = searchVC.searchBar.text
        
        detectChanges()
    }
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        showchatController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSearchVC"{
            if let destination = segue.destination as? SearchVC {
                destination.previousText = sender as! String
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        sections = [
            FriendListSection(section: "摯友", thumbnailImages: [], titles: [], metTimes: []),
            FriendListSection(section: "普通朋友", thumbnailImages: [], titles: [], metTimes: [])
        ]
        
        //setFirendList
        FirebaseService.shared().setFriendList { (normalFriends, favoriteFriends) in
            
            print(normalFriends.count)
            print(favoriteFriends.count)
            
            for obj in normalFriends {
                self.sections[1].titles.append(obj.title)
                self.sections[1].thumbnailImages.append(obj.thumbImage)
                self.sections[1].metTimes.append(obj.metTimes)
            }
            
            for obj in favoriteFriends {
                self.sections[0].titles.append(obj.title)
                self.sections[0].thumbnailImages.append(obj.thumbImage)
                self.sections[0].metTimes.append(obj.metTimes)
            }
            
            refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func detectChanges(){
        
        if searchBar.text == nil || searchBar.text == "" {
            //定義searchMode
            print("A")
            whetherInSearchMode = false
            tableView.reloadData()
            
        } else {
            
            print("B")
            whetherInSearchMode = true
            
            filterArray()
        }
    }
    
    func filterArray(){
        
        filteredSections = [
            FriendListSection(section: "摯友", thumbnailImages: [], titles: [], metTimes: []),
            FriendListSection(section: "普通朋友", thumbnailImages: [], titles: [], metTimes: [])
        ]
        
        filteredNormalFriends = normalFriends.filter({$0.title.range(of: self.searchBar.text!) != nil})
        filteredFavoriteFriends = favoriteFriends.filter({$0.title.range(of: self.searchBar.text!) != nil})
        
        for obj in filteredNormalFriends {
            self.filteredSections[1].titles.append(obj.title)
            self.filteredSections[1].thumbnailImages.append(obj.thumbImage)
            self.filteredSections[1].metTimes.append(obj.metTimes)
        }
        
        for obj in filteredFavoriteFriends {
            self.filteredSections[0].titles.append(obj.title)
            self.filteredSections[0].thumbnailImages.append(obj.thumbImage)
            self.filteredSections[0].metTimes.append(obj.metTimes)
        }
        
        tableView.reloadData()
    }
    
    //出現聊天頁面
    func showchatController() {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}

extension FriendListVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if let searchBarText = self.searchBar.text {
            self.performSegue(withIdentifier: "toSearchVC", sender: searchBarText)
        } else {
            self.performSegue(withIdentifier: "toSearchVC", sender: "")
        }
        
        searchBar.endEditing(true)
        searchBar.reloadInputViews()
    }
}

extension FriendListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if whetherInSearchMode == false {
            return sections[section].titles.count
        } else {
            return filteredSections[section].titles.count
        }
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
        
        if whetherInSearchMode == false {
    
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
       
        } else {
            
            let titles = self.filteredSections[indexPath.section].titles
            let title = titles![indexPath.row]
            
            let thumbnailImages = self.filteredSections[indexPath.section].thumbnailImages
            let thumbnailImage = thumbnailImages![indexPath.row]
            
            let metTimes = self.filteredSections[indexPath.section].metTimes
            let metTime = metTimes![indexPath.row]
            
            cell.nameLbl.text = title
            cell.profileImageView.image = thumbnailImage
            cell.metTimesLbl.text = "遇到次數：\(metTime)"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
