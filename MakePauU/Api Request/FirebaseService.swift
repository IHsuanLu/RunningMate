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

class FirebaseService: NSObject{
    
    static let sharedInstance = FirebaseService()
    
    func setFirstPage(completion: @escaping (String, Int, Int, Double, UIImage) -> ()){
       
        var dbReference: DatabaseReference?
        var storage: Storage?
        
        dbReference = Database.database().reference()
        storage = Storage.storage()
        
        _ = dbReference?.child("members").child(MemberId.sharedInstance.member_id).observe(.value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, AnyObject>{
                
                let name = value["name"] as! String
                let count = value["total_count"] as! Int
                let distance = value["total_distance(km)"] as! Int
                let average_time = value["average_time"] as! Double
                
                if let profileImages = value["profileImageURL"] as? NSArray{
                    if let profileImageURL = profileImages[0] as? String{
                        
                        print(profileImageURL)
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
    
    func checkIfCluster(completion: @escaping (Bool) -> ()){
        
        var dbReference: DatabaseReference?
        
        dbReference = Database.database().reference()

        _ = dbReference?.child("running_player").child(MemberId.sharedInstance.member_id).observe(.value, with: { (snapshot) in
            
            if let _ = snapshot.value as? Dictionary<String, AnyObject> {
                completion(true)
            } else {
                completion(false)
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
    
    
}


