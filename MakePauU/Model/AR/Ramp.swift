//
//  Ramp.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/25.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import Foundation
import SceneKit

class Ramp{
    
    class func getPresent() -> SCNNode{
        
        //grabbing the entire scene
        let obj = SCNScene(named: "art.scnassets/present.dae")
        //grab the node outta scene
        let node = obj?.rootNode.childNode(withName: "present", recursively: true)
        node?.scale = SCNVector3Make(1, 1, 1)  //大小
        node?.position = SCNVector3Make(0, -1, -2) //位置
        //throw it into scene
        return node!
    }
    
    class func setRotate(node: SCNNode, completion: @escaping () -> ()){
        
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                let rotate = SCNAction.repeat(SCNAction.rotateBy(x: 0, y: CGFloat(1 * Double.pi), z: 0, duration: 0.5), count: 2)
                node.runAction(rotate)
            }
            
            completion()
        }
    }
    
    //改成trophy
    class func getTrophy() -> SCNNode{
        
        //grabbing the entire scene
        let obj = SCNScene(named: "art.scnassets/booook.dae")
        //grab the node outta scene
        let node = obj?.rootNode.childNode(withName: "booook", recursively: true)
        node?.scale = SCNVector3Make(1, 1, 1)  //大小
        node?.position = SCNVector3Make(0, -1, -2) //位置
        //throw it into scene
        return node!
    }
}
