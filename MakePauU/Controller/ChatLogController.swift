


import UIKit
import Firebase
class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "打些東西吧"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "聊天室"
        
        collectionView?.backgroundColor = UIColor.white
        
        func setupInputComponents() {
            let containerView = UIView()
            containerView.backgroundColor = UIColor.gray
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(containerView)
            
            
            //ios10 constraint anchors
            //x,y,w,h
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
            separatorLineView.backgroundColor = UIColor.black
            separatorLineView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(separatorLineView)
            //x,y,w,h
            separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
            separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
    }
    @objc func handleSend() {
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        //輸入資料庫的方式
        let values = ["text": inputTextField.text!]
        childRef.updateChildValues(values)
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}
