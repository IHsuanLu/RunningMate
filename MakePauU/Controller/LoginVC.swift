//
//  LoginVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/1.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    
    var loginInfo = LoginInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        loginBtn.layer.cornerRadius = 8.0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func gatherInfo(completion: () -> ()){
        
        if let email = emailTextField.text {
            loginInfo.email = email
        } else {
            setAlert(string: "Email")
        }
        
        if let password = passwordTextField.text{
            loginInfo.password = password
        } else {
            setAlert(string: "Password")
        }
        
        completion()
    }
    
    func setAlert(string: String){
        let alert = UIAlertController(title: "請輸入\(string)", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setAlert(){
        
        let alert = UIAlertController(title: "帳號或密碼錯誤！", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        gatherInfo(completion:{
            ApiService.sharedInstance.postLogin(loginInfo: loginInfo, completion: { member_id in
                
                if member_id != "login failed"{
                    MemberId.sharedInstance.member_id = member_id
                    self.performSegue(withIdentifier: "toFirstPageVC", sender: nil)
                } else {
                    self.setAlert()
                }
            })
        })
    }
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFirstPageVC"{
            let barViewControllers = segue.destination as! UITabBarController
            let nav = barViewControllers.viewControllers![0] as! UINavigationController
            _ = nav.topViewController as! FirstPageVC
        }
    }
}
