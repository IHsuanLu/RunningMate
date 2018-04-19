//
//  RegisterVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/8.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

//imagePickerController 需要 UIImagePickerControllerDelegate, UINavigationControllerDelegate

class RegisterVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let userSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoImageView.image = userSelectedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func returnBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPhotoBtnPressed(_ sender: UIButton) {
        
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
    
    @IBAction func radioBtnPressed(_ sender: DLRadioButton) {
        // tag -> 1 for male ; 2 for female
    }
    
    @IBAction func preferRadioBtnPressed(_ sender: Any) {
        // tag -> 1 for male ; 2 for female ; 3 for both
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
            
        for i in 1900...2018{
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

