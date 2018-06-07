//
//  FirebaseService.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/7.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

import MapKit

class FirebaseService: NSObject{
    
    static private var _sharedInstance: FirebaseService?
    
    var dbReference: DatabaseReference = Database.database().reference()
    
    final class func shared() -> FirebaseService { // change class to final to prevent override
        
        guard let uwShared = _sharedInstance else {
            _sharedInstance = FirebaseService()
            return _sharedInstance!
        }
        
        return uwShared
    }
    
    class func destroy() {
        _sharedInstance = nil
    }
    
    private override init() {
        print("init singleton")
    }
    
    deinit {
        print("deinit singleton")
    }
    
    func setFirstPage(completion: @escaping (String, Int, Double, Double, UIImage) -> ()){
       
        var storage: Storage?
        storage = Storage.storage()
        
        _ = dbReference.child("members").child(MemberId.sharedInstance.member_id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, AnyObject>{
                
                let name = value["name"] as! String
                let count = value["total_count"] as! Int
                let distance = value["total_distance(km)"] as! Double
                let average_time = value["average_time"] as! Double
                
                if let profileImages = value["profileImageURL"] as? NSArray{
                    if let profileImageURL = profileImages[0] as? String{
                        
                        let storageRef = storage?.reference(forURL: profileImageURL)
                        
                        storageRef?.downloadURL(completion: { (url, error) in
                            
                            do {
                                let data = try Data(contentsOf: url!)
                                let pic = UIImage(data: data)
                                
                                completion(name, count, distance, average_time, pic!)
                            } catch {
                                print(error)
                            }
                        })
                    }
                }
            }
        })
    }
    
    func checkIfCluster(completion: @escaping (Bool, Int) -> ()){
    
        _ = dbReference.child("running_player").child(MemberId.sharedInstance.member_id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, AnyObject> {
                if let mate = value["跑友"] as? Dictionary<String, AnyObject> {
                    
                    let numberOfmates = mate.count + 1
                    
                    completion(true, numberOfmates)
                }
            } else {
                
                completion(false, 0)
            }
        })
    }
    
    func setFinalConfirm(completion: @escaping (Double, [RoomMemberItem]) -> ()){
        
        var storage: Storage?
        storage = Storage.storage()
        
        //把資料送回去
        var items = [RoomMemberItem]()
        
        let myGroup = DispatchGroup()
        
        _ = dbReference.child("running_player").child(MemberId.sharedInstance.member_id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, AnyObject>{
                
                let estimate_distance = value["最遠直線距離"] as! Double
                
                if let running_mate = value["跑友"] as? Dictionary<String, AnyObject> {
                    
                    for obj in running_mate {
                        
                        myGroup.enter()
                        
                        let name = obj.value["name"] as! String
                                
                        if let profileImages = obj.value["profileImageURL"] as? NSArray{
                                    
                            let profileImageURL = profileImages[0] as! String
                                    
                            let storageRef = storage?.reference(forURL: profileImageURL)
                            storageRef?.downloadURL(completion: { (url, error) in
                                        
                                do {
                                    
                                    let data = try Data(contentsOf: url!)
                                    let pic = UIImage(data: data)
                                            
                                    let item = RoomMemberItem(thumbImage: pic!, title: name)
                                    items.append(item)
                                            
                                    myGroup.leave()
                                    
                                } catch {
                                    print(error)
                                }
                            })
                        }
                    }
                }
                
                myGroup.notify(queue: DispatchQueue.main, execute: {
                    
                    completion(estimate_distance, items)
                })
            }
        })
    }
    
    func setCircle(completion: @escaping ([CLLocation]) -> ()){
        
        let myGroup = DispatchGroup()
        
        var locations: [CLLocation] = []
        
        _ = dbReference.child("running_player").child(MemberId.sharedInstance.member_id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, AnyObject> {
                
                if let firstCircle = value["第一圈圓心"] as? Dictionary<String, AnyObject>, let secondCircle = value["第二圈圓心"] as? Dictionary<String, AnyObject>, let thirdCircle = value["第三圈圓心"] as? Dictionary<String, AnyObject>, let forthCircle = value["第四圈圓心"] as? Dictionary<String, AnyObject> {
                   
                    let circles: [Dictionary<String, AnyObject>] = [firstCircle, secondCircle, thirdCircle, forthCircle]
                    
                    for obj in circles {
                        
                        myGroup.enter()
                        
                        if let x = obj["x"] as? CLLocationDegrees, let y = obj["y"] as? CLLocationDegrees{
                            
                            let location = CLLocation(latitude: y, longitude: x)
                            
                            locations.append(location)
                            
                            myGroup.leave()
                        }
                    }
                }
                
                
                myGroup.notify(queue: DispatchQueue.main, execute: {
                    completion(locations)
                })
            }
        })
    }
    
    func setAirDrop(completion: @escaping ([CLLocation], [String], [String], [Int]) -> ()){
        
        let myGroup = DispatchGroup()
        
        var locations: [CLLocation] = []
        var gifts: [String] = []
        var airdrop_urls: [String] = []
        var statuses: [Int] = []
        
        _ = dbReference.child("running_player").child(MemberId.sharedInstance.member_id).child("空投").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, AnyObject>{
            
                if let firstAirDrop = value["first"] as? Dictionary<String, AnyObject>, let secondAirDrop = value["second"] as? Dictionary<String, AnyObject>, let thirdAirDrop = value["third"] as? Dictionary<String, AnyObject> {
                    
                    let airdrops : [Dictionary<String, AnyObject>] = [firstAirDrop, secondAirDrop, thirdAirDrop]
                    
                    for obj in airdrops {
                        
                        myGroup.enter()
                        
                        if let x = obj["x"] as? CLLocationDegrees, let y = obj["y"] as? CLLocationDegrees, let gift = obj["gift"] as? String, let airdrop_url = obj["airdrops_url"] as? String, let status = obj["status"] as? Int{
                            
                            let location = CLLocation(latitude: y, longitude: x)
                            
                            locations.append(location)
                            gifts.append(gift)
                            airdrop_urls.append(airdrop_url)
                            statuses.append(status)
                            
                            myGroup.leave()
                        }
                    }
                    
                    myGroup.notify(queue: DispatchQueue.main, execute: {
                        completion(locations, gifts, airdrop_urls, statuses)
                    })
                }
            }
        })
    }
    
    func updateInbox(number: Int){

        dbReference.child("email").child(MemberId.sharedInstance.member_id).child("第\(number)封").updateChildValues(["狀態":1])
    }
    
    func updateAirdropStatus(whichAirDrop: Int){
        
        var whichAirDropString: String! 
        
        switch whichAirDrop {
        case 0:
            whichAirDropString = "first"
        case 1:
            whichAirDropString = "second"
        case 2:
            whichAirDropString = "third"
        default:
            whichAirDropString = ""
        }
        
        dbReference.child("running_player").child(MemberId.sharedInstance.member_id).child("空投").child(whichAirDropString).updateChildValues(["status":1])
    }
    
    func setInbox(completion: @escaping ([MailboxItem]) -> ()){
        
        let myGroup = DispatchGroup()

        var emails: [MailboxItem] = []
        
        _ = dbReference.child("email").child(MemberId.sharedInstance.member_id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, AnyObject>{
                
                //if let first = value["第1封"] as? Dictionary<String, AnyObject>
                var letters: [Dictionary<String, AnyObject>] = []
                
                for i in 1...value.count {
                    if let letter = value["第\(i)封"] as? Dictionary<String, AnyObject>{
                        letters.append(letter)
                    }
                }
                
                for obj in letters {
                    
                    myGroup.enter()
                    
                    var email = MailboxItem()
                    
                    if let content = obj["內容"] as? String, let sender = obj["寄件者"] as? String, let date = obj["收件時間"] as? String, let status = obj["狀態"] as? Int, let title = obj["標題"] as? String {
                        
                        email.content = content
                        email.sender = sender
                        email.date = date
                        email.ifSeen = status
                        email.title = title
                        
                        emails.append(email)
                        
                        myGroup.leave()
                    }
                }
                
                myGroup.notify(queue: DispatchQueue.main, execute: {
                    completion(emails)
                })
            }
        })
    }
    
    func getFriendInfo(completion: @escaping ([EndingInfo]) -> ()){

        var storage: Storage?
        storage = Storage.storage() 
        
        let myGroup = DispatchGroup()
        
        var friendInfos: [EndingInfo] = []
        
        _ = dbReference.child("running_player").child(MemberId.sharedInstance.member_id).child("跑友").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, AnyObject>{
                
                for obj in value {

                    myGroup.enter()
                    
                    var friendInfo = EndingInfo()
                    
                    friendInfo.id = obj.key
                    
                    if let birth_day = obj.value["birth_day"] as? String, let birth_month = obj.value["birth_month"] as? String, let birth_year = obj.value["birth_year"] as? String, let name = obj.value["name"] as? String, let profileImages = obj.value["profileImageURL"] as? NSArray, let sex = obj.value["sex"] as? String{
                        
                        friendInfo.name = name
                        friendInfo.birth = "\(birth_year) / \(birth_month) / \(birth_day)"
                        friendInfo.sex = sex
                        
                        if let profileImageURL = profileImages[0] as? String{
                            
                            let storageRef = storage?.reference(forURL: profileImageURL)
                            
                            storageRef?.downloadURL(completion: { (url, error) in
                                
                                do {
                                    let data = try Data(contentsOf: url!)
                                    let pic = UIImage(data: data)
                                    
                                    friendInfo.image = pic!
                                    
                                    friendInfos.append(friendInfo)
                                    
                                    myGroup.leave()
                                } catch {
                                    print(error)
                                }
                            })
                        }
                    }
                }
                
                myGroup.notify(queue: DispatchQueue.main, execute: {
                    completion(friendInfos)
                })
            }
        })
    }
    
    func getLatestStat(completion: @escaping (Double, Double, Double) -> ()){
        
        _ = dbReference.child("historical_data").child(MemberId.sharedInstance.member_id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, AnyObject>{
                
                //if let first = value["第1封"] as? Dictionary<String, AnyObject>
                var datas: [Dictionary<String, AnyObject>] = []
                
                for i in 1...value.count {
                    if let data = value["第\(i)筆"] as? Dictionary<String, AnyObject>{
                        datas.append(data)
                    }
                }
                
                if let total_distance = datas[datas.count - 1]["total_distance(km)"] as? Double, let average_time = datas[datas.count - 1]["average_time"] as? Double, let total_time = datas[datas.count - 1]["total_time"] as? Double{
                    
                    completion(total_distance, average_time, total_time)
                }
            }
        })
    }
    
    func setFriendList(completion: @escaping ([FriendList], [FriendList]) -> ()){
        
        var storage: Storage?
        storage = Storage.storage()
        
        let myGroup = DispatchGroup()
        let myGroup2 = DispatchGroup()
        
        var normalFriends: [FriendList] = []
        var favoriteFriends: [FriendList] = []
        
        var ending = 2
        
        
        _ = dbReference.child("friends_list").child(MemberId.sharedInstance.member_id).child("好友").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, AnyObject>{
                
                if let normal = value["一般好友"] as? Dictionary<String, AnyObject> {
                    
                    for obj in normal {
                        
                        myGroup.enter()
                        
                        if let personalData = obj.value["個人資料"] as? Dictionary<String, AnyObject>, let metTimes = obj.value["遇到次數"] as? Int {
                            
                            let name = personalData["name"] as! String
                            
                            if let profileImages = personalData["profileImageURL"] as? NSArray{
                                
                                let profileImageURL = profileImages[0] as! String
                                
                                let storageRef = storage?.reference(forURL: profileImageURL)
                                storageRef?.downloadURL(completion: { (url, error) in
                                    
                                    do {
                                        
                                        let data = try Data(contentsOf: url!)
                                        let pic = UIImage(data: data)
                                        
                                        let normalFriend = FriendList(thumbImage: pic!, title: name, metTimes: metTimes)
                                        
                                        normalFriends.append(normalFriend)
                                        
                                        myGroup.leave()
                                        
                                    } catch {
                                        print(error)
                                    }
                                })
                            }
                        }
                    }
                } else {
                    ending = 1
                }
                
                if let favorite = value["摯友"] as? Dictionary<String, AnyObject> {
                    
                    for obj in favorite {
                        
                        myGroup2.enter()
                        
                        if let personalData = obj.value["個人資料"] as? Dictionary<String, AnyObject>, let metTimes = obj.value["遇到次數"] as? Int {
                            
                            let name = personalData["name"] as! String
                            
                            if let profileImages = personalData["profileImageURL"] as? NSArray{
                                
                                let profileImageURL = profileImages[0] as! String
                                
                                let storageRef = storage?.reference(forURL: profileImageURL)
                                storageRef?.downloadURL(completion: { (url, error) in
                                    
                                    do {
                                        
                                        let data = try Data(contentsOf: url!)
                                        let pic = UIImage(data: data)
                                        
                                        let favoriteFriend = FriendList(thumbImage: pic!, title: name, metTimes: metTimes)
                                        
                                        favoriteFriends.append(favoriteFriend)
                                        
                                        myGroup2.leave()
            
                                    } catch {
                                        print(error)
                                    }
                                })
                            }
                        }
                    }
                    
                    switch ending {
                    case 1:  //都摯友
                        myGroup2.notify(queue: DispatchQueue.main, execute: {
                            completion(normalFriends, favoriteFriends)
                        })
                    case 2:  //都有
                        myGroup.notify(queue: DispatchQueue.main, execute: {
                            myGroup2.notify(queue: DispatchQueue.main, execute: {
                                completion(normalFriends, favoriteFriends)
                            })
                        })
                    default:  //都一般
                        myGroup.notify(queue: DispatchQueue.main, execute: {
                            completion(normalFriends, favoriteFriends)
                        })
                    }
                }
            }
        })
    }
    
    func getAirdrops(completion: @escaping ([String], [UIImage]) -> ()){
        
        var storage: Storage?
        storage = Storage.storage()

        var titles: [String] = []
        var QRcodes: [UIImage] = []
        
        let myGroup = DispatchGroup()
        
        _ = dbReference.child("members").child(MemberId.sharedInstance.member_id).child("airdrops").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSArray {
                
                for i in 0...value.count - 1{
                    
                    myGroup.enter()
                    
                    if let content = value[i] as? Dictionary<String, AnyObject> {
                        
                        let title = content["名稱"] as! String
                        let url = content["url"] as! String
                        
                        let urlArray = url.components(separatedBy: "&token=")
                        
                        let storageRef = storage?.reference(forURL: urlArray[0])
                        storageRef?.downloadURL(completion: { (url, error) in
                            
                            do {
                                
                                let data = try Data(contentsOf: url!)
                                let pic = UIImage(data: data)
                                
                                titles.append(title)
                                QRcodes.append(pic!)
                                
                                myGroup.leave()
                                
                            } catch {
                                print(error)
                            }
                        })
                    }
                }
                
                myGroup.notify(queue: DispatchQueue.main, execute: {
                    completion(titles, QRcodes)
                })
            }
        })
    }
}


