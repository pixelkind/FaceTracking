//
//  ViewController.swift
//  FaceTracking
//
//  Created by Garrit on 13.06.19.
//  Copyright © 2019 Garrit GmbH. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        (view as? ARSCNView)?.session.run(configuration)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face Tracking not supported!")
        }
        (view as? ARSCNView)?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        (view as? ARSCNView)?.session.pause()
    }

}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return nil
        }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        
        guard let tongueOut = faceAnchor.blendShapes[.tongueOut]?.floatValue,
            let leftEye = faceAnchor.blendShapes[.eyeBlinkLeft]?.floatValue,
            let rightEye = faceAnchor.blendShapes[.eyeBlinkRight]?.floatValue else {
            return
        }
        if tongueOut > 0.8 && tongueOut <= 1.0{
            
            
            if leftEye > 0.5 && leftEye <= 1.0 && rightEye > 0.5 && rightEye <= 1.0 {
                print("🤪")
            }

            
        }
    }
    
}
