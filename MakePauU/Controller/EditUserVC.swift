//
//  EditUserVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/30.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit


//把暱稱也送過來

class EditUserVC: UIViewController {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    
    @IBOutlet weak var textFieldTabe: UITableView!
    @IBOutlet weak var textViewTable: UITableView!
    
    @IBOutlet weak var textViewTableHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    var whichImageView: Int!
    
    var datas: [DataItem]!
    
    var testArray: [TextFieldItem]!
    var testArray2: [TextViewItem]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testArray = [
            TextFieldItem(title: "暱稱: ", content: "Jamie"),
            TextFieldItem(title: "性別: ", content: "女生"),
            TextFieldItem(title: "居住地: ", content: ""),
            TextFieldItem(title: "就讀於 / 任職於: ", content: ""),
            TextFieldItem(title: "生日: ", content: ""),
            TextFieldItem(title: "感情取向: ", content: "")
        ]
        
        testArray2 = [
            TextViewItem(title: "興趣愛好: ", content: " \n \n \n \n \n \n"),
            TextViewItem(title: "最近的困擾: ", content: " \n \n \n \n \n \n"),
            TextViewItem(title: "想嘗試的事: ", content: " \n \n \n \n \n \n")
        ]
        
        adjustConstraint()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.textViewTableHeight?.constant = self.textViewTable.contentSize.height
        
        self.contentViewHeight.constant = 315 + self.view.frame.width + self.textViewTableHeight.constant + 20
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
    
    func adjustUITextViewHeight(arg : UITextView){
        
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
    }
}

extension EditUserVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // info contains our image data
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let userSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        switch whichImageView {
        case 1:
            imageView1.image = userSelectedImage
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

extension EditUserVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == textFieldTabe{
            return 6
        } else if tableView == textViewTable{
            return 3
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == textFieldTabe {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            
            var titleArray = ["暱稱: ", "性別: ", "居住地: ", "就讀於 / 任職於: ", "生日: ", "感情取向: "]
            var contentArray = ["死亡少女", "女", "台北市", "政治大學資管系", datas[0].content, datas[1].content]
        
            cell.titleLbl.text = titleArray[indexPath.row]
            cell.contentTextField.text = contentArray[indexPath.row]
            
            return cell
        
        } else if tableView == textViewTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! TextViewCell
            
            var titleArray = ["興趣愛好: ", "最近的困擾: ", "想嘗試的事："]
            var contentArray = [datas[2].content, datas[3].content, datas[4].content]
            
            cell.titleLbl.text = titleArray[indexPath.row]
            cell.contentTextView.text = contentArray[indexPath.row]

            cell.contentTextView.translatesAutoresizingMaskIntoConstraints = false
            
            return cell
        }
        
        return UITableViewCell()
    }
}
