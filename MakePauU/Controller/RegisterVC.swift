//
//  RegisterVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/8.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

//imagePickerController 需要 UIImagePickerControllerDelegate, UINavigationControllerDelegate

class RegisterVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectPhotoBtn: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var nameTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    
    @IBOutlet weak var dayTextField: DateTextField!
    @IBOutlet weak var monthTextField: DateTextFieldLong!
    @IBOutlet weak var yearTextField: DateTextField!
    
    @IBOutlet weak var maleRadio: DLRadioButton!
    @IBOutlet weak var femaleRadio: DLRadioButton!
    @IBOutlet weak var preferMaleRadio: DLRadioButton!
    @IBOutlet weak var preferFemaleRadio: DLRadioButton!
    @IBOutlet weak var preferBothRadio: DLRadioButton!
    
    
    // picker
    var dayPickerView = UIPickerView()
    var monthPickerView = UIPickerView()
    var yearPickerView = UIPickerView()
    
    var days = [String]()
    var years = [String]()
    var months = ["January", "Feburary", "March", "April", "May", "June", "July", "Augest", "September", "October", "November", "December"]
    
    var toolBar = UIToolbar()
    
    // gather Info and send to ApiService
    var registerInfo = RegisterInfo()
    var sex: String!
    var sex_prefer: String!
    
    // profileImageURL
    var profileImageURL: String!
    var member_id: String!
    
    //是否成功
    var registerStatus: Bool!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        
        arrayGenerator()
        
        DispatchQueue.main.async {
            self.dayPickerView.delegate = self
            self.monthPickerView.delegate = self
            self.yearPickerView.delegate = self
            
            self.dayPickerView.dataSource = self
            self.monthPickerView.dataSource = self
            self.yearPickerView.dataSource = self
        }
        
        setSelection()
        setButtonColor()
        
        photoImageView.layer.cornerRadius = 50
        scrollView.delaysContentTouches = false
    }
    
    // info contains our image data
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            photoImageView.image = editImage
        } else if let userSelectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            photoImageView.image = userSelectedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func returnBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPhotoBtnPressed(_ sender: UIButton) {
        setImagePicker()
    }
    
    func setImagePicker(){
        
        // imagePickerController things
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        
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
    
    @IBAction func radioBtnPressed(_ sender: DLRadioButton) {
        if sender.tag == 1{
            sex = "male"
        } else if sender.tag == 2 {
            sex = "female"
        }
    }
    
    @IBAction func preferRadioBtnPressed(_ sender: DLRadioButton) {
        if sender.tag == 1{
            sex_prefer = "male"
        } else if sender.tag == 2 {
            sex_prefer = "female"
        } else if sender.tag == 3 {
            sex_prefer = "both"
        }
    }
    
    
    func setButtonColor(){
        maleRadio.setTitleColor(UIColor(netHex: 0x666666), for: .selected)
        femaleRadio.setTitleColor(UIColor(netHex: 0x666666), for: .selected)
        preferMaleRadio.setTitleColor(UIColor(netHex: 0x666666), for: .selected)
        preferFemaleRadio.setTitleColor(UIColor(netHex: 0x666666), for: .selected)
        preferBothRadio.setTitleColor(UIColor(netHex: 0x666666), for: .selected)
    }
    
    //判斷日期對錯！
    func arrayGenerator(){
    
        for i in 1...31{
            self.days.append("\(i)")
        }
            
        for i in 1970...2018{
            self.years.append("\(i)")
        }
    }
    
    public func setSelection(){
        
        // 設定toolBar
        // done, cancel button
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // 安裝
        dayTextField.inputAccessoryView = toolBar
        dayTextField.inputView = dayPickerView
        
        monthTextField.inputAccessoryView = toolBar
        monthTextField.inputView = monthPickerView
        
        yearTextField.inputAccessoryView = toolBar
        yearTextField.inputView = yearPickerView
    }
    
    // for bar button action
    @objc func doneClick() {
        dayTextField.resignFirstResponder()
        monthTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
    }
    
    
    @IBAction func createAccountBtnPressed(_ sender: UIButton) {
        
        print("Button Pressed")
        
        // 確定有資料
        gatherInfo(completion: {
            
            // 確定有照片
            if let photo = photoImageView.image  {
               
                if photo != #imageLiteral(resourceName: "photo") {

                    // APIRequest
                    ApiService.sharedInstance.postResgister(registerInfo: registerInfo, completion: { registerStatus, member_id in
                        
                        //把成功與否傳回來
                        self.registerStatus = registerStatus
                        
                        if self.registerStatus == true {
                            self.member_id = member_id  //if let
                            self.uplaodImage(photo)
                        }
                        
                        self.setAlert()
                    })
                    
                } else {
                    
                    let alert = UIAlertController(title: "請選擇照片", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        })
    }
    
    //progressBlock -> completion handler
    func uplaodImage(_ photo: UIImage){
        
        // get reference to the storage (get id)
        let ref = Storage.storage().reference().child("\(member_id!)").child("first pic")
        
        if let uploadData = UIImagePNGRepresentation(photo) {
            
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
        
        let ref = Storage.storage().reference().child("\(member_id!)").child("first pic")
        
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
        ref.child("members").child("\(member_id!)").updateChildValues(["profileImageURL":["\(profileImageURL!)"]])
    }
    
    
    
    func gatherInfo(completion: () -> ()){
        
        if let email = emailTextField.text {
            registerInfo.email = email
        } else {
            setAlert(string: "Email")
        }
        
        if let name = nameTextField.text {
            registerInfo.name = name
        } else {
            setAlert(string: "Name")
        }
        
        if let password = passwordTextField.text{
            registerInfo.password = password
        } else {
            setAlert(string: "Password")
        }
        
        if let birth_year = yearTextField.text{
            registerInfo.birth_year = birth_year
        } else {
            setAlert(string: "Birth Year")
        }
        
        if let birth_month = monthTextField.text{
            registerInfo.birth_month = birth_month
        } else {
            setAlert(string: "Birth Month")
        }
        
        if let birth_day = dayTextField.text{
            registerInfo.birth_day = birth_day
        } else {
            setAlert(string: "Birth Day")
        }
        
        if let sex = sex{
            registerInfo.sex = sex
        } else {
            setAlert(string: "Sex")
        }
        
        if let sex_prefer = sex_prefer{
            registerInfo.sex_prefer = sex_prefer
        } else {
            setAlert(string: "Sex Prefer")
        }
        
        completion()
    }
    
    func setAlert(string: String){
        let alert = UIAlertController(title: "\(string)欄位 未填寫！", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setAlert(){
        
        if self.registerStatus == true{
            let alert = UIAlertController(title: "註冊成功", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "此Email帳號已經註冊過了！", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension RegisterVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == dayPickerView{
            return days.count
        } else if pickerView == monthPickerView{
            return months.count
        } else {
            return years.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == dayPickerView{
            return days[row]
        } else if pickerView == monthPickerView{
            return months[row]
        } else {
            return years[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == dayPickerView{
            dayTextField.text = days[row]
        } else if pickerView == monthPickerView{
            monthTextField.text = months[row]
        } else {
            yearTextField.text = years[row]
        }
    }

}

