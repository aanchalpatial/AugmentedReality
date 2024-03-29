//
//  NewspaperViewController.swift
//  AugmentedReality
//
//  Created by Aanchal Patial on 23/08/19.
//  Copyright © 2019 AP. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class NewspaperViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet weak var sceneView: ARSCNView!
    
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
        if let imageToLookFor = ARReferenceImage.referenceImages(inGroupNamed: "Newspaper Images", bundle: Bundle.main) {
            configuration.detectionImages = imageToLookFor
            configuration.maximumNumberOfTrackedImages = 1

        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor{
            
            let videoNode = SKVideoNode(fileNamed: "potter.mp4")
            videoNode.play()
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
            videoNode.yScale = -1.0
            videoScene.addChild(videoNode)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = videoScene
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -Float.pi/2
            node.addChildNode(planeNode)
            
            
            
        }
        return node
    }

}
