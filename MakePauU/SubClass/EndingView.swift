//
//  EndingView.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/2.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

protocol EndingViewDelegate: class {
    
    func dismissBlackView()
}

class EndingView: UIView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 34, width: self.frame.width, height: self.frame.width)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 1000
        view.bounces = false
        return view
    }()
    
    lazy var nameAndAgeLbl: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 16, y: self.frame.width + 44, width: 150, height: 30)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(netHex: 0x333333)
        return label
    }()
    
    lazy var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: self.frame.width - 144, y: self.frame.width + 50, width: 18, height: 18)
        imageView.image = #imageLiteral(resourceName: "like")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var fansNumberLbl: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: self.frame.width - 126, y: self.frame.width + 50, width: 110, height: 18)
        label.font = UIFont(name: "Helvetica Neue", size: 15)
        label.textColor = UIColor(netHex: 0x666666)
        label.text = "跑友人數: 800"
        label.textAlignment = .right
        return label
    }()
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: self.frame.width + 78, width: self.frame.width, height: scrollView.contentSize.height - (self.frame.width + 78))
        tableView.isScrollEnabled = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: "EndingCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "EndingCell")
        
        return tableView
    }()
    
    lazy var tagImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 38, width: 180, height: 80)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()

    
    var counter: Int!
    var testArray: [EndingItem]!
    
    //data
    var id: String!
    var name: String!
    var birth: String!
    var profileImage: UIImage!
    var sex: String!
    
    weak var delegate: EndingViewDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let window = UIApplication.shared.keyWindow{
            
            backgroundColor = UIColor(netHex: 0xFFFFFF)
            frame.size = CGSize(width: window.frame.size.width - 50, height: window.frame.size.height - 80)
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOffset = CGSize(width:0,height: 2.0)
            layer.shadowRadius = 2.0
            layer.shadowOpacity = 1.0
            layer.masksToBounds = false
            
            
            self.addSubview(scrollView)
            setupScrollView()

            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 30)
            titleLabel.backgroundColor = UIColor(netHex: 0xFBA100)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.textColor = UIColor.white
            titleLabel.textAlignment = .center
            titleLabel.text = "本局其他跑友"
            self.addSubview(titleLabel)
            
            scrollView.addSubview(likeImageView)
            scrollView.addSubview(fansNumberLbl)

            
            imageView.image = profileImage
            scrollView.addSubview(imageView)
            
            nameAndAgeLbl.text = name
            scrollView.addSubview(nameAndAgeLbl)
            
            scrollView.addSubview(tableView)
            self.addSubview(tagImageView)
            
            setGestureRecognizer()
        }
    }

    
    func setGestureRecognizer(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
    }
    
    //constraint
    func setupScrollView(){
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }

    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer){
        
        if gesture.direction == .left{
            if let window = UIApplication.shared.keyWindow {
                
                self.tagImageView.frame.origin.x = self.frame.width - 200
                
                UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.frame = CGRect(x: window.frame.size.width * -1 , y: self.frame.origin.y + 40, width: self.frame.width, height: self.frame.height)
                    self.tagImageView.image = #imageLiteral(resourceName: "dislike")
                    
                    print(self.counter)
                    
                
                }, completion: { (finish: Bool) in
                    
                    self.isHidden = true
                })
            }
        } else if gesture.direction == .right{
            if let window = UIApplication.shared.keyWindow {
                UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.frame = CGRect(x: window.frame.size.width * 1 , y: self.frame.origin.y + 40, width: self.frame.width, height: self.frame.height)
                   
                    self.tagImageView.image = #imageLiteral(resourceName: "favorite")
                    
                    if let id = self.id{
                        print(id)
                        FavoriteFriendIDs.sharedInstance.favoriteFriends.append(id)
                    }
                    
                    print(self.counter)
                    
                }, completion: { (finish: Bool) in
                    
                    self.isHidden = true
                })
            }
        }
        
        if let counter = self.counter {
            if counter == 0 {
                ApiService.sharedInstance.add_to_friend(favoriteFriendsID: FavoriteFriendIDs.sharedInstance.favoriteFriends) {
                    
                    self.delegate?.dismissBlackView()
                    print("Done!")
                }
            }
        }
    }
    
    func adjustFrame(){
        
        scrollView.contentSize.height = tableView.contentSize.height + self.frame.height - 120
        tableView.frame.size.height = scrollView.contentSize.height - (self.frame.width + 78)
    }
    
    //self.? = ? 帶過來
    init(frame: CGRect, counter: Int, id: String, name: String, birth: String, profileImage: UIImage, sex: String) {
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.white
        self.counter = counter
        
        self.id = id
        self.name = name
        self.birth = birth
        self.profileImage = profileImage
        self.sex = sex
        
        testArray = [
            EndingItem(title: "暱稱: ", content: "死亡少女"),
            EndingItem(title: "性別: ", content: "\(sex)"),
            EndingItem(title: "居住地: ", content: "台北市"),
            EndingItem(title: "就讀於 / 任職於: ", content: "政治大學"),
            EndingItem(title: "生日: ", content: "\(birth)"),
            EndingItem(title: "感情取向: ", content: "喜歡男生"),
            EndingItem(title: "興趣愛好: ", content: "喜歡看各種類型的電影和徹夜不眠追劇\n國中時喜歡看天真浪漫不切實際的愛情片\n幻想男主角都是我的老公/n年幼無知憧憬愛情\n殊不知 那只是電影 只是 電影老公們都是有收錢的\n最終娶的都不是我 :(\n傷了心\n高中時喜歡古裝武打片\n看古人們輕功飛簷走壁\n以為自己也可以傷了身"),
            EndingItem(title: "最近的困擾: ", content: "嘴巴上每天都說想減肥\n可是看到美食又忘記自己立下的毒誓\n希望有人可以陪我一起運動"),
            EndingItem(title: "想嘗試的事: ", content: "想找一項活動\n可以療癒我的身心靈")
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EndingView: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EndingCell", for: indexPath) as? EndingCell{
            
            cell.titleLbl.text = testArray[indexPath.row].title
            cell.contentLbl.text = testArray[indexPath.row].content

            adjustFrame()
            
            return cell
        }

        return UITableViewCell()
    }
}
