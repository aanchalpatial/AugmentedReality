//
//  ScaleViewController.swift
//  AugmentedReality
//
//  Created by Aanchal Patial on 23/08/19.
//  Copyright © 2019 AP. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ScaleViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet weak var sceneView: ARSCNView!
    var dotNodeArray = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodeArray.count >= 2 {
            for node in dotNodeArray {
                node.removeFromParentNode()
            }
            dotNodeArray = [SCNNode]()
        }
        if let touch = touches.first{
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = results.first {
                print(hitResult)
                addDot(atLocation: hitResult)
                
                
            }
        }
    }
    
    func addDot( atLocation hitResult : ARHitTestResult){
        
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        dotGeometry.materials = [material]
        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        dotNodeArray.append(dotNode)
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        if dotNodeArray.count >= 2 {
            calculateDistance()
        }
        
    }
    
    func calculateDistance(){
        let startPoint = dotNodeArray[0]
        let endPoint = dotNodeArray[1]
        let distance = sqrt( pow(endPoint.position.x-startPoint.position.x, 2) + pow(endPoint.position.y-startPoint.position.y, 2) + pow(endPoint.position.z-startPoint.position.z, 2) ) * 100
        updateDistance(text: "\(distance) cm", position: endPoint.position)
        
    }
    
    func updateDistance(text: String, position: SCNVector3){
        textNode.removeFromParentNode()
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x, position.y+0.01, position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    

    

}
