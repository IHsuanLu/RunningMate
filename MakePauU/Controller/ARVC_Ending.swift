//
//  ARVC_Ending.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/30.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import ARCL
import CoreLocation

class ARVC_Ending: UIViewController, ARSCNViewDelegate {

    var selectedRamp: SCNNode!
    
    var sceneLocationView = SceneLocationView()
    
    var scene: SCNScene!
    var annotationNode: LocationNode!
    
    let settingEnding = SettingEnding()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        addTrophy()
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
    
    func setAlert(){
        
        // create the alert
        let alert = UIAlertController(title: "點擊打開朋友資訊！", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: { (action) in
            
            if let ramp = self.selectedRamp{
                ramp.removeFromParentNode()
                self.selectedRamp = nil
            }
            
            //先跳出來
            self.performSegue(withIdentifier: "unwindFromAREnding", sender: nil)      
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
    
    func addTrophy(){
        
        // add present
        let trophy = Ramp.getTrophy()
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.2 * Double.pi), z: 0, duration: 2))
        trophy.runAction(rotate)
        scene.rootNode.addChildNode(trophy)
    }
}
