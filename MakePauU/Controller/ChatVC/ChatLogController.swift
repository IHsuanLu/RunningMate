//
//  ChatLogController.swift
//  chatchatchat
//
//  Created by Hsieh Tony on 2018/6/6.
//  Copyright © 2018 Hsieh Tony. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let toId = user!.id!

        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        //不確定
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            
            
            
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            
            messagesRef.observe(.value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String:AnyObject] else {
                    return
                }
                
                let message = Message(dictionary: dictionary)
                message.setValuesForKeys(dictionary)
                
                
                
                //do we need to attempt filtering anymore?
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "打些東西吧"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
        textField.delegate = self
    }()
    
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //把第一個聊天往下推
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.keyboardDismissMode = .interactive
        
//        setupInputComponents()
//
//        //設定鍵盤
//        setupKeyboardObservers()
    }
    
    lazy var inputContainerView: UIView =  {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //至叫出鍵盤時 叫太多次
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func handlekeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
        //keyboard 次數
        let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? Double
        
        //當鍵盤出現時 視窗往上移
        containerViewButtomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func handlekeyboardWillHide(notification: NSNotification) {
       
        
        let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? Double
        
         //當鍵盤收回時 視窗下移
        containerViewButtomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        //決定框框是橘色或灰色
        setupCell(cell: cell, message: message)
        //改變聊天筐的寬度
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForTex(text: message.text!).width + 32
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        //決定框框是橘色或灰色
        if message.fromId == Auth.auth().currentUser?.uid {
            //出去是橘底白字
            cell.bubbleView.backgroundColor = ChatMessageCell.runningColor
            cell.textView.textColor = UIColor.white
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            // 得到是灰底黑字
            cell.bubbleView.backgroundColor = UIColor(red: 240, green: 240, blue: 240)
            cell.textView.textColor = UIColor.black
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var height: CGFloat = 80
        
        //讓藍色格子是變動大小的
        if let text = messages[indexPath.item].text {
            height = estimateFrameForTex(text: text).height + 20
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForTex(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes:
            //[NSFontAttributeName: UIFont.systemFontOfSize(16)]
            [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16.0)], context: nil)
    }
    
    var containerViewButtomAnchor: NSLayoutConstraint?
    
        func setupInputComponents() {
            let containerView = UIView()
            containerView.backgroundColor = UIColor.lightGray
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(containerView)
            
            
            //ios10 constraint anchors
            //x,y,w,h
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            
            containerViewButtomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            containerViewButtomAnchor?.isActive = true
            
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            
            let sendButton = UIButton(type: .system)
            sendButton.setTitle("Send", for: .normal)
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            containerView.addSubview(sendButton)
            //x,y,w,h
            sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
            sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
            
            containerView.addSubview(inputTextField)
            //x,y,w,h
            inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
            inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
            inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
            
            let separatorLineView = UIView()
            separatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
            separatorLineView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(separatorLineView)
            //x,y,w,h
            separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
            separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
    
    @objc func handleSend() {
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        //輸入資料庫的方式
        let toId = user!.id!
        //送出和接收方
        let fromId = Auth.auth().currentUser?.uid
        let timestamp = NSDate().timeIntervalSince1970
        
        let values = ["toId": toId, "timestamp": timestamp, "text": inputTextField.text!, "fromId": fromId] as [String : Any]
        
        //childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (Error, ref) in
            if Error != nil {
                print(Error)
                return
            }
            
            //在每次按送出後清出打字格
            self.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId!).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId!)
            
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}//class

