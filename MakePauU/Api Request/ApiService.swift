//
//  ApiService.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/29.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class ApiService: NSObject{
    
    static let sharedInstance = ApiService()
    

    
    func postResgister(registerInfo: RegisterInfo, completion: @escaping (Bool, String) -> ()){
        
        let checkSessionURL = URL(string: "http://140.119.19.149:8000/register_member/")
        
        let session = URLSession.shared
        var request = URLRequest(url: checkSessionURL!)
        
        let testString = "email=\(registerInfo.email!)&name=\(registerInfo.name!)&password=\(registerInfo.password!)&birth_year=\(registerInfo.birth_year!)&birth_month=\(registerInfo.birth_month!)&birth_day=\(registerInfo.birth_day!)&sex=\(registerInfo.sex!)&sex_prefer=\(registerInfo.sex_prefer!)"
        
        
        request.httpMethod = "POST"
        request.httpBody = testString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            //JSONSerialization -> 把Json形式轉成dictionary
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
                    
                    print("responseJSON from CheckSession = \(json)")

                    if let register_status = json["register_status"] as? String{
                        
                        if let member_id = json["member_id"] as? String{
                            
                            if register_status == "註冊成功"{
                                completion(true, member_id)
                            } else {
                                completion(false, "")
                            }
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    func postLogin(loginInfo: LoginInfo, completion: @escaping (String) -> ()){
        
        let checkSessionURL = URL(string: "http://140.119.19.149:8000/login_member/")
        
        let session = URLSession.shared
        var request = URLRequest(url: checkSessionURL!)
        
        let testString = "email=\(loginInfo.email!)&password=\(loginInfo.password!)"
        
        request.httpMethod = "POST"
        request.httpBody = testString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            //JSONSerialization -> 把Json形式轉成dictionary
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
        
                    if let member_id = json["member_id"] as? String{
                        
                        print(member_id)
                        completion(member_id)
                    }
                    
                    print("responseJSON from CheckSession = \(json)")
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    func postUserPosition(userLocation: CLLocationCoordinate2D, completion: @escaping () -> ()) {
        //mapView.userLocation.coordinate
        
        let circleURL = URL(string: "http://140.119.19.149:8000/circle/")
        
        let session = URLSession.shared
        var request = URLRequest(url: circleURL!)
        
        let testString = "x=\(userLocation.longitude)&y=\(userLocation.latitude)&member_id=\(MemberId.sharedInstance.member_id)"
        
        request.httpMethod = "POST"
        request.httpBody = testString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            //JSONSerialization -> 把Json形式轉成dictionary
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
                    
                    print("responseJSON from CheckSession = \(json)")
                    
                    completion()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    func start_game_cancel(completion: @escaping () -> ()){
        
        let circleURL = URL(string: "http://140.119.19.149:8000/start_game_cancel/")
        
        let session = URLSession.shared
        var request = URLRequest(url: circleURL!)
        
        let testString = "member_id=\(MemberId.sharedInstance.member_id)"
        
        request.httpMethod = "POST"
        request.httpBody = testString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            //JSONSerialization -> 把Json形式轉成dictionary
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
                    
                    print("responseJSON from CheckSession = \(json)")
                    
                    completion()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    
    func checkSession(completion: @escaping (Bool) -> ()){
        
        let circleURL = URL(string: "http://140.119.19.149:8000/check_session/")
        
        let session = URLSession.shared
        var request = URLRequest(url: circleURL!)
        
        let testString = ""
        
        request.httpMethod = "POST"
        request.httpBody = testString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            //JSONSerialization -> 把Json形式轉成dictionary
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
                    
                    print("responseJSON from CheckSession = \(json)")
                    
                    if let result = json["result"] as? String, let member_id = json["member_id"] as? String{
                        
                        if result == "login already" && member_id != "no id"{
                           
                            MemberId.sharedInstance.member_id = member_id
                            completion(true)
                            
                        } else {
                            completion(false)
                        }
                    }                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    func logout(completion: @escaping () -> ()){
        
        let circleURL = URL(string: "http://140.119.19.149:8000/logout/")
        
        let session = URLSession.shared
        var request = URLRequest(url: circleURL!)
        
        let testString = ""
        
        request.httpMethod = "POST"
        request.httpBody = testString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            //JSONSerialization -> 把Json形式轉成dictionary
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
                    
                    print("responseJSON from CheckSession = \(json)")
                    
                    completion()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    func app_terminate(completion: @escaping () -> ()){
        
        let circleURL = URL(string: "http://140.119.19.149:8000/app_terminate/")
        
        let session = URLSession.shared
        var request = URLRequest(url: circleURL!)
        
        let testString = "member_id=\(MemberId.sharedInstance.member_id)"
        
        request.httpMethod = "POST"
        request.httpBody = testString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            //JSONSerialization -> 把Json形式轉成dictionary
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
                    
                    print("responseJSON from CheckSession = \(json)")
                    
                    completion()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    
    func delete_from_main_pool(completion: @escaping () -> ()){
        
        let circleURL = URL(string: "http://140.119.19.149:8000/delete_from_main_pool/")
        
        let session = URLSession.shared
        var request = URLRequest(url: circleURL!)
        
        let testString = "member_id=\(MemberId.sharedInstance.member_id)"
        
        request.httpMethod = "POST"
        request.httpBody = testString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            //JSONSerialization -> 把Json形式轉成dictionary
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
                    
                    print("responseJSON from CheckSession = \(json)")
                    
                    completion()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    func during_game_cancel(statsInfo: StatsInfo, completion: @escaping () -> ()){
        
        let circleURL = URL(string: "http://140.119.19.149:8000/during_game_cancel/")
        
        let session = URLSession.shared
        var request = URLRequest(url: circleURL!)
        
        let testString = "member_id=\(MemberId.sharedInstance.member_id)&total_distance(km)=\(statsInfo.total_distance!)&total_time=\(statsInfo.total_time!)"
        
        request.httpMethod = "POST"
        request.httpBody = testString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            //JSONSerialization -> 把Json形式轉成dictionary
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
                    
                    print("responseJSON from CheckSession = \(json)")
                    
                    completion()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    func add_to_history(giftsTaken: [String], statsInfo: StatsInfo, completion: @escaping () -> ()){
    
        let circleURL = URL(string: "http://140.119.19.149:8000/add_to_history/")
        
        let session = URLSession.shared
        var request = URLRequest(url: circleURL!)
        
        
        let testString = "member_id=\(MemberId.sharedInstance.member_id)&total_distance(km)=\(statsInfo.total_distance!)&total_time=\(statsInfo.total_time!)&airdrops=\(giftsTaken)"
        
        print(testString)
        
        request.httpMethod = "POST"
        request.httpBody = testString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            //JSONSerialization -> 把Json形式轉成dictionary
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
                    
                    print("responseJSON from CheckSession = \(json)")
                    
                    completion()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    func add_to_friend(favoriteFriendsID: [String], completion: @escaping () -> ()){
    
        let circleURL = URL(string: "http://140.119.19.149:8000/add_to_friend/")
        
        let session = URLSession.shared
        var request = URLRequest(url: circleURL!)
        
        
        let testString = "member_id=\(MemberId.sharedInstance.member_id)&favorite=\(favoriteFriendsID)"
        
        print(testString)
        
        request.httpMethod = "POST"
        request.httpBody = testString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            //JSONSerialization -> 把Json形式轉成dictionary
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
                    
                    print("responseJSON from CheckSession = \(json)")
                    
                    completion()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
}
