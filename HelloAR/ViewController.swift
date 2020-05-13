//
//  ViewController.swift
//  HelloAR
//
//  Created by Mohammad Azam on 5/7/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.autoenablesDefaultLighting = true
        
        sceneView.debugOptions = [.showFeaturePoints]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        

        registerGestureRecognizers()
        
       // addBoxToScene()
       // addSphereToScene()
        
        //addModelToScene()
        
    }
    
    private func addModelToScene(at position: SCNVector3) {
        
        let plantScene = SCNScene(named: "PUSHILIN_plant.scn")!
        let plantNode = plantScene.rootNode.childNode(withName: "plant", recursively: true)!
        
        plantNode.position = position
        plantNode.position.y += 0.4
        plantNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        plantNode.categoryBitMask = 1
       // plantNode.scale = SCNVector3(0.2,0.2,0.2)
        
        sceneView.scene.rootNode.addChildNode(plantNode)
        
    }
    
    private func addSphereToScene() {
        
        let sphere = SCNSphere(radius: 0.4)
        sphere.firstMaterial?.diffuse.contents = UIImage(named: "earth.jpg")
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(0, 0, -0.8)
        
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }
    
    private func addBoxToScene() {
        
        let box = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        box.materials = [material]
        
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(0, 0, -0.5)
        
        sceneView.scene.rootNode.addChildNode(boxNode)
        
    }
    
    func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer: UITapGestureRecognizer) {
       
        let sceneView = recognizer.view as! ARSCNView
        let touch = recognizer.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(touch, types: .existingPlane)
        if !hitTestResult.isEmpty {
            
            guard let hitTest = hitTestResult.first else {
                return
            }
            
            let position = SCNVector3(hitTest.worldTransform.columns.3.x, hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)
            
            addModelToScene(at: position)
            
        }
        
        
        /*
        let hitTestResult = sceneView.hitTest(touch, options: nil)
        if !hitTestResult.isEmpty {
         
            guard let hitTest = hitTestResult.first else {
                    return
            }
            
            let node = hitTest.node
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.random()
            
            node.geometry?.materials = [material]
        } */
        
    }
 
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
           
            let plane = SCNPlane(width: 0.8, height: 0.8)
            
            plane.firstMaterial?.diffuse.contents = UIImage(named: "wood.jpg")
            plane.firstMaterial?.isDoubleSided = true
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.categoryBitMask = 2
            planeNode.position = SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y, anchor.transform.columns.3.z)
            planeNode.physicsBody = SCNPhysicsBody(type: .static, shape:nil)
            planeNode.eulerAngles.x = .pi/2
            
            sceneView.scene.rootNode.addChildNode(planeNode)
        }
        
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

}
