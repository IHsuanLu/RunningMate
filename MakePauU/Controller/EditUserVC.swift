//
//  EditUserVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/30.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


//把暱稱也送過來

class EditUserVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var livingTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var sexPreferTextField: UITextField!
    
    @IBOutlet weak var interestTextView: UITextView!
    @IBOutlet weak var problemTextView: UITextView!
    @IBOutlet weak var triesTextView: UITextView!
    
    @IBOutlet weak var problemHeight: NSLayoutConstraint!
    @IBOutlet weak var interestHeight: NSLayoutConstraint!
    @IBOutlet weak var triesHeight: NSLayoutConstraint!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    
    var whichImageView: Int!
    
    var userInfo: UserInfo!
    var textViewContentArray: [String]!
    
    var profileImageURL = String()
    
    var afterChangesInfo = UserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let window = UIApplication.shared.keyWindow {
            window.tintColor = UIColor(netHex: 0xE9A11A)
        }
        
        imageView1.image = userInfo.profileImage!
        
        updateUI()
        
        adjustTextViewHeight(textView: interestTextView, heightConstraint: interestHeight)
        adjustTextViewHeight(textView: problemTextView, heightConstraint: problemHeight)
        adjustTextViewHeight(textView: triesTextView, heightConstraint: triesHeight)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        self.contentViewHeight.constant = self.view.frame.width + 562 + problemHeight.constant + interestHeight.constant + triesHeight.constant
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == interestTextView {
            adjustTextViewHeight(textView: interestTextView, heightConstraint: interestHeight)
        } else if textView == problemTextView {
            adjustTextViewHeight(textView: problemTextView, heightConstraint: problemHeight)
        } else if textView == triesTextView {
            adjustTextViewHeight(textView: triesTextView, heightConstraint: triesHeight)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        AdjustKeyboard.sharedInstance.keyboardStatus_TextView(frameView: contentView, activeTextView: textView)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        AdjustKeyboard.sharedInstance.keyboardStatus(frameView: contentView, activeTextField: textField)
    }
    
    func adjustTextViewHeight(textView: UITextView, heightConstraint: NSLayoutConstraint) {
        
        let fixedWidth = self.view.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        heightConstraint.constant = newSize.height + 20
        
        self.view.layoutIfNeeded()
    }
    
    func updateUI(){
        
        nameTextField.text = userInfo.name
        sexTextField.text = userInfo.sex
        livingTextField.text = userInfo.living
        schoolTextField.text = userInfo.school
        birthTextField.text = userInfo.birth
        sexPreferTextField.text = userInfo.sex_prefer
        
        interestTextView.text = userInfo.interest
        problemTextView.text = userInfo.problem
        triesTextView.text = userInfo.tries
        
        self.contentViewHeight.constant = self.view.frame.width + 482 + problemHeight.constant + interestHeight.constant + triesHeight.constant
        
        self.contentView.reloadInputViews()
    }
    
    
    
    @IBAction func onButton1(_ sender: Any) {
        whichImageView = 1
        setImageController()
    }
    
    @IBAction func onButton2(_ sender: Any) {
        whichImageView = 2
        setImageController()
    }
    
    @IBAction func onButton3(_ sender: Any) {
        whichImageView = 3
        setImageController()
    }
    
    @IBAction func onButton4(_ sender: Any) {
        whichImageView = 4
        setImageController()
    }
    
    @IBAction func onButton5(_ sender: Any) {
        whichImageView = 5
        setImageController()
    }
    
    @IBAction func onButton6(_ sender: Any) {
        whichImageView = 6
        setImageController()
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        setAlert()
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        print("Pressed")
        
        gaterInfo {
            ApiService.sharedInstance.updateUser(userInfo: self.afterChangesInfo, completion: {
                
                //unwind
                self.performSegue(withIdentifier: "unwindFromEditVC", sender: nil)
            })
        }
    }
    
    func gaterInfo(completion: () -> ()){
        
        if let profileImage = imageView1.image {
            afterChangesInfo.profileImage = profileImage
        } else {
            afterChangesInfo.profileImage = UIImage()
        }
        
        if let name = nameTextField.text {
            afterChangesInfo.name = name
        } else {
            afterChangesInfo.name = " "
        }
        
        if let sex = sexTextField.text {
            afterChangesInfo.sex = sex
        } else {
            afterChangesInfo.sex = " "
        }
        
        if let living = livingTextField.text {
            afterChangesInfo.living = living
        } else {
            afterChangesInfo.living = " "
        }
        
        if let school = schoolTextField.text {
            afterChangesInfo.school = school
        } else {
            afterChangesInfo.school = " "
        }
        
        if let birth = birthTextField.text {
            afterChangesInfo.birth = birth
        } else {
            afterChangesInfo.birth = " "
        }
        
        if let sex_prefer = sexPreferTextField.text {
            afterChangesInfo.sex_prefer = sex_prefer
        } else {
            afterChangesInfo.sex_prefer = " "
        }
        
        if let interest = interestTextView.text {
            afterChangesInfo.interest = interest
        } else {
            afterChangesInfo.interest = " "
        }
        
        if let problem = problemTextView.text {
            afterChangesInfo.problem = problem
        } else {
            afterChangesInfo.problem = " "
        }
        
        if let tries = triesTextView.text {
            afterChangesInfo.tries = tries
        } else {
            afterChangesInfo.tries = " "
        }
        
        completion()
    }
    
    //progressBlock -> completion handler
    func uplaodImage(_ photo: UIImage){
        
        // get reference to the storage (get id)
        let ref = Storage.storage().reference().child(MemberId.sharedInstance.member_id).child("first pic")
        
        if let uploadData = UIImageJPEGRepresentation(photo, 0.05) {
            
            _ = ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                self.downloadURL()
            })
        }
    }
    
    func downloadURL(){
        
        let ref = Storage.storage().reference().child(MemberId.sharedInstance.member_id).child("first pic")
        
        ref.downloadURL { (url, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let profileImageURL = url?.absoluteString {
                    self.profileImageURL = profileImageURL
                    self.writeURL()
                }
            }
        }
    }
    
    func writeURL(){
        
        let ref = Database.database().reference()
        ref.child("members").child(MemberId.sharedInstance.member_id).child("profileImageURL").updateChildValues(["0" :"\(profileImageURL)"])
    }
    
    func setAlert(){
        
        let alert = UIAlertController(title: "確定放棄編輯？", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setImageController(){
       
        // imagePickerController things
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        let actionSheet = UIAlertController(title: "照片來源", message: "選擇大頭貼照片來源", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "相機", style: .default, handler: { (action: UIAlertAction) in
            
            //如果相機是available的
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("智障手機")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "照片圖庫", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    } 
    
    func adjustConstraint(){
        
        var imageViews = [UIImageView]()
        imageViews = [imageView1, imageView2, imageView3, imageView4, imageView5, imageView6]
        
        for view in imageViews{
            for constraint in view.constraints{
                if constraint.identifier == "125"{
                    constraint.constant = self.view.frame.size.width / 3
                }
                
                if constraint.identifier == "250"{
                    constraint.constant = (self.view.frame.size.width / 3) * 2
                }
            }
        }
    }
}

extension EditUserVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // info contains our image data
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let userSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        switch whichImageView {
        case 1:
            imageView1.image = userSelectedImage
            self.uplaodImage(self.imageView1.image!)
        case 2:
            imageView2.image = userSelectedImage
        case 3:
            imageView3.image = userSelectedImage
        case 4:
            imageView4.image = userSelectedImage
        case 5:
            imageView5.image = userSelectedImage
        case 6:
            imageView6.image = userSelectedImage
        default:
            break
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
