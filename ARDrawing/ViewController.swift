//
//  ViewController.swift
//  ARDrawing
//
//  Created by Carlo Namoca on 2018-06-05.
//  Copyright © 2018 Carlo Namoca. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var drawButton: UIButton!
    
    let configuration = ARWorldTrackingConfiguration()
    
    var color = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.delegate = self
        self.sceneView.session.run(configuration)
    }

    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        //print("Rendering")
        
        // We need to extract the location and orientation
        // everytime the renderer gets called
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera = orientation + location
        
        //print(orientation.x, orientation.y, orientation.z)
        DispatchQueue.main.async {
            if self.drawButton.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentPositionOfCamera
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                print("Draw button is being pressed")
            } else {
                let pointerNode = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointerNode.name = "pointer"
                pointerNode.position = currentPositionOfCamera
                
                // Loops through every sceneView node
                self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }

                }
                
                pointerNode.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
                self.sceneView.scene.rootNode.addChildNode(pointerNode)
            }
        }

    }
    
    @IBAction func erase(_ sender: Any) {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
    
    
    
}

// Modify the "+" operator
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

