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
    
    static let sharedInstance = FirebaseService()
    
    private override init() {
        
    }
    
    func setFirstPage(completion: @escaping (String, Int, Double, Double, UIImage) -> ()){
       
        var dbReference: DatabaseReference?
        var storage: Storage?
        
        dbReference = Database.database().reference()
        storage = Storage.storage()
        
        _ = dbReference?.child("members").child(MemberId.sharedInstance.member_id).observe(.value, with: { (snapshot) in
            
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
                
                //如何存image
            }
        })
    }
    
    func checkIfCluster(completion: @escaping (Bool, Int) -> ()){
        
        var dbReference: DatabaseReference?
        
        dbReference = Database.database().reference()

        _ = dbReference?.child("running_player").child(MemberId.sharedInstance.member_id).observe(.value, with: { (snapshot) in
            
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
        
        var dbReference: DatabaseReference?
        var storage: Storage?
        
        //把資料送回去
        var items = [RoomMemberItem]()
        
        let myGroup = DispatchGroup()
        
        dbReference = Database.database().reference()
        storage = Storage.storage()

        _ = dbReference?.child("running_player").child(MemberId.sharedInstance.member_id).observe(.value, with: { (snapshot) in
            
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

        var dbReference: DatabaseReference?
        var locations: [CLLocation] = []

        dbReference = Database.database().reference()
        
        let myGroup = DispatchGroup()
        
        _ = dbReference?.child("running_player").child(MemberId.sharedInstance.member_id).observe(.value, with: { (snapshot) in
            
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
    
    func setAirDrop(completion: @escaping ([CLLocation], [String]) -> ()){
        
        var dbReference: DatabaseReference?
        dbReference = Database.database().reference()
        
        var locations: [CLLocation] = []
        var gifts: [String] = []
        
        
        let myGroup = DispatchGroup()
        
        _ = dbReference?.child("running_player").child(MemberId.sharedInstance.member_id).child("空投").observe(.value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, AnyObject>{
            
                if let firstAirDrop = value["first"] as? Dictionary<String, AnyObject>, let secondAirDrop = value["second"] as? Dictionary<String, AnyObject>, let thirdAirDrop = value["third"] as? Dictionary<String, AnyObject> {
                    
                    let airdrops : [Dictionary<String, AnyObject>] = [firstAirDrop, secondAirDrop, thirdAirDrop]
                    
                    for obj in airdrops {
                        
                        myGroup.enter()
                        
                        if let x = obj["x"] as? CLLocationDegrees, let y = obj["y"] as? CLLocationDegrees, let gift = obj["gift"] as? String{
                            
                            let location = CLLocation(latitude: y, longitude: x)
                            
                            locations.append(location)
                            gifts.append(gift)
                            
                            myGroup.leave()
                        }
                    }
                    
                    myGroup.notify(queue: DispatchQueue.main, execute: {
                        completion(locations, gifts)
                    })
                }
            }
        })
    }
    
    func updateInbox(number: Int){
        
        let dbReference = Database.database().reference()
        
        dbReference.child("email").child(MemberId.sharedInstance.member_id).child("第\(number)封").updateChildValues(["狀態":1])
    }
    
    func setInbox(completion: @escaping ([MailboxItem]) -> ()){
        
        var dbReference: DatabaseReference?
        dbReference = Database.database().reference()
        
        let myGroup = DispatchGroup()

        var emails: [MailboxItem] = []
        
        _ = dbReference?.child("email").child(MemberId.sharedInstance.member_id).observe(.value, with: { (snapshot) in
            
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
}

