//
//  DiceViewController.swift
//  AugmentedReality
//
//  Created by Aanchal Patial on 23/08/19.
//  Copyright © 2019 AP. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class DiceViewController: UIViewController , ARSCNViewDelegate{

    
    @IBOutlet weak var sceneView: ARSCNView!
    var nodeArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
        
        //        //bring sun in the room
        //        let sun = SCNSphere(radius: 0.2)
        //        let material = SCNMaterial()
        //        material.diffuse.contents = UIImage(named: "art.scnassets/8k_sun.jpg")
        //        sun.materials = [material]
        //        let node = SCNNode(geometry: sun)
        //        node.position = SCNVector3(0, 0, -0.5)
        //        sceneView.scene.rootNode.addChildNode(node)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "")
        plane.materials = [material]
        
        let planeNode = SCNNode()
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        planeNode.geometry = plane
        
        node.addChildNode(planeNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if let hitResult = results.first {
                print(hitResult)
                addNode(atLocation: hitResult)
                
                
            }
        }
    }
    func addNode( atLocation hitResult: ARHitTestResult){
        
        // Create a new scene
        let boxScene = SCNScene(named: "art.scnassets/ErdemitGrass.scn")!
        if let boxNode = boxScene.rootNode.childNode(withName: "Erde_mit_Grass", recursively: true){
            boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                          hitResult.worldTransform.columns.3.y+boxNode.boundingSphere.radius,
                                          hitResult.worldTransform.columns.3.z)
            
            nodeArray.append(boxNode)
            // Set the scene to the view
            sceneView.scene.rootNode.addChildNode(boxNode)
            
        }
        
    }
    
    func rollAllNode(){
        for node in nodeArray{
            let randomX = Float(arc4random_uniform(4)) * (Float.pi/2)
            let randomZ = Float(arc4random_uniform(4)) * (Float.pi/2)
            
            node.runAction(SCNAction.rotateBy(x: CGFloat(randomX*5), y: 0, z: CGFloat(randomZ*5), duration: 1))
        }
    }
    
    
    @IBAction func removeAllNodes(_ sender: UIBarButtonItem) {
        for node in nodeArray {
            node.removeFromParentNode()
            nodeArray.removeFirst()
        }
    }
    
    @IBAction func rotateAllNodes(_ sender: UIBarButtonItem) {
        rollAllNode()
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAllNode()
    }

    

}
