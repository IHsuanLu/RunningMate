//
//  ARVC_New.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/26.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import ARCL
import CoreLocation

class ARVC_New: UIViewController, ARSCNViewDelegate {

    var selectedRamp: SCNNode!
    
    var sceneLocationView = SceneLocationView()
    
    var scene: SCNScene!
    var annotationNode: LocationNode!
    
    //Segue
    var locationCoordinate = CLLocationCoordinate2D()
    var distance = CLLocationDistance()
    var gift: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("!!!!!!!!!!!!!!!!!\(gift!)")
        print("!!!!!!!!!!!\(locationCoordinate)")
        
        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        

        //create new scene
        scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneLocationView.autoenablesDefaultLighting = true
        //set the scene to view
        sceneLocationView.scene = scene
        
        
        //handle tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneLocationView.addGestureRecognizer(tap)
        
        addPresent()
        addReturnBtn()
        setTag()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        
        //run the view session
        sceneLocationView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //paus the view session
        sceneLocationView.session.pause()
    }
    
    //分辨是不是被點了
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer){
        
        //for 分辨你在那個View裡面按了哪裡
        let p = gestureRecognizer.location(in: sceneLocationView)
        let hitResults = sceneLocationView.hitTest(p, options: [:])
        
        //see if anything is hit
        if hitResults.count == 1 {
            //grab the note that we hit
            let nodeIsHit = hitResults[0].node
            
            selectedRamp = nodeIsHit
            
            Ramp.setRotate(node: selectedRamp, completion:{
                
                sleep(UInt32(1.2))
                
                //處理點到之後的事情
                self.setAlert()
            })
        } else {
            return
        }
    }
    
    @objc func returnBtnPressed(){
        
        deleteTag()
        performSegue(withIdentifier: "unwindFromARVC", sender: nil)
    }
    
    func setAlert(){
        
        // create the alert
        let alert = UIAlertController(title: "恭喜您！\n 獲得折價券 乙張", message: "\(gift!)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: { (action) in
            
            if let ramp = self.selectedRamp{
                ramp.removeFromParentNode()
                self.selectedRamp = nil
            }
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func addReturnBtn(){
        
        let button = UIButton()
        button.frame = CGRect(x: 12, y: 20, width: 48, height: 48)
        button.setImage(#imageLiteral(resourceName: "return_yellow"), for: .normal)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnBtnPressed)))
        sceneLocationView.addSubview(button)
    }
    
    func addPresent(){
        
        // add present
        let present = Ramp.getPresent()
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.2 * Double.pi), z: 0, duration: 2))
        present.runAction(rotate)
        scene.rootNode.addChildNode(present)
    }
    
    func setTag(){
        
        let coordinate = CLLocationCoordinate2D(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        let location = CLLocation(coordinate: coordinate, altitude: 0)
        
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 30)))
        label.text = "\(distance) M"
        label.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        label.drawHierarchy(in: label.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        annotationNode = LocationAnnotationNode(location: location, image: image!)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }
    
    func deleteTag(){
        sceneLocationView.removeLocationNode(locationNode: annotationNode)
    }
}
