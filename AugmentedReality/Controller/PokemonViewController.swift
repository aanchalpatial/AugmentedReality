//
//  PokemonViewController.swift
//  AugmentedReality
//
//  Created by Aanchal Patial on 23/08/19.
//  Copyright © 2019 AP. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PokemonViewController: UIViewController , ARSCNViewDelegate{

    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if let imagesToLookFor = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            configuration.detectionImages = imagesToLookFor
            configuration.maximumNumberOfTrackedImages = 3
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
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let pokemonName = imageAnchor.referenceImage.name
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.3)
            let planeNode = SCNNode(geometry: plane)
            //planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            //why not above line
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
            
            if let pokemonScene = SCNScene(named: "art.sznassets/\(pokemonName).scn"){
                if let pokemonNode = pokemonScene.rootNode.childNodes.first {
                    pokemonNode.eulerAngles.x = .pi/2
                    planeNode.addChildNode(pokemonNode)
                }
            }
        }
        return node
    }
    
    
}
