//
//  ViewController.swift
//  CalARie
//
//  Created by Brendon Ho on 9/22/17.
//  Copyright © 2017 Brendon Ho. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SceneKit.ModelIO
import Vision
import Photos
import DeckTransition
import SwiftyJSON

class ViewController: UIViewController, ARSCNViewDelegate {

    var post : [String] = []
    var num : [Int] = []

    @IBOutlet var sceneView: ARSCNView!
    var nutrition : [SCNNode] = []
    
    var buttons : [SCNNode] = []
    
    var tapGesture = UITapGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var fillerView: UIView!
    override func viewDidLoad() {
        
        fillerView.layer.cornerRadius = 10
        super.viewDidLoad()
        activityIndicator.alpha = 0.0;
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognize:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        downSwipe.direction = .up;
        self.view.addGestureRecognizer(downSwipe);
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Enable plane detection
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    //swipe up gesture
    @objc func dismissKeyboard(){
        performSegue(withIdentifier: "MoveToHistory", sender: nil)
        let modal = HistoryTableViewController()
        let transitionDelegate = DeckTransitioningDelegate()
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        present(modal, animated: true, completion: nil)
    }
    
    var fetchingResults = false
    func convertCItoUIImage(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        return UIImage(cgImage: cgImage)
    }
    
    @objc func handleTap(gestureRecognize: UITapGestureRecognizer) {
        
        print("Screen Hit")
        print("1----------------")
        let cardHitTestResults = sceneView.hitTest(gestureRecognize.location(in: sceneView), options: nil)
        
        for result in cardHitTestResults {
            print("CARD HIT")
            print(result)
            if buttons.contains(result.node) {
                guard let components = result.node.name?.components(separatedBy: "C==3") else {
                    print("Malformed node name")
                    continue
                }

                
                if let dataFromString = components[1].data(using: .utf8, allowLossyConversion: false) {
                    let nutritionFacts = JSON(data: dataFromString)
                    let cal = Int(nutritionFacts[0]["Energy"][0].string!)
                    FoodManager.shared().addPillHistory(foodName: components[0], calories:cal!, nutrition: nutritionFacts)

                }
               
                return
            }
            if nutrition.contains(result.node) {
                //remove all nodes, parents and children
                result.node.parent?.childNodes[0].runAction(SCNAction.scale(to: 0.0, duration: 0.3) )
                result.node.runAction(SCNAction.scale(to: 0.0, duration: 0.3) )
                result.node.parent?.childNodes[0].runAction(SCNAction.fadeOpacity(to: 0.0, duration: 0.3) )
                result.node.runAction(SCNAction.fadeOpacity(to: 0.0, duration: 0.3) )
                
                result.node.runAction(SCNAction.wait(duration: 0.5), completionHandler: {
                    result.node.parent?.removeFromParentNode()
                    self.buttons.remove(at: self.nutrition.index(of: result.node)!)
                    self.nutrition.remove(at: self.nutrition.index(of: result.node)!)
                })
                return
            }
            for node in nutrition {
                if result.node == node.parent {
                    return
                }
            }
        }
        
        let screenCentre : CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
        
        let arHitTestResults : [ARHitTestResult] = sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
        
        if let closestResult = arHitTestResults.first {
            print("2----------------")
            // Get Coordinates of HitTest
            let transform : matrix_float4x4 = closestResult.worldTransform
            //sceneView.session.add(anchor: ARAnchor(transform: transform))
            let worldCoord = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
            if pixbuff == nil { return }
            let ciImage = CIImage(cvPixelBuffer: pixbuff!)
            var image = convertCItoUIImage(cmage: ciImage)
            image = image.crop(to: CGSize(width: image.size.width, height: image.size.width))
            image = image.zoom(to: 4.0) ?? image
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { success, error in
                if success {
                    print("Saved successfully")
                    // Saved successfully!
                }
                else if let error = error {
                    // Save photo failed with error
                }
                else {
                    // Save photo failed with no error
                }
            })
            
            print("Sending Image")
            if fetchingResults == true {
                return
            } else {
                fetchingResults = true
                activityIndicator.alpha = 1.0
                activityIndicator.startAnimating()
            }
            
            GoogleAPIManager.shared().identifyDrug(image: image, completionHandler: { (result) in
                self.fetchingResults = false
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0.0;
                }
                if let result = result {
                    print(result);
                    print("3----------------")
                    /*for pill in DataManager.shared().pillHistoryData {
                    }*/
                    //make dictionary
                    
                    
                    var dictionary = Dictionary<String, Array<Any>>()

                    var nutritionFacts = result.maximum["report"]["food"]["nutrients"].array!

                        for item in nutritionFacts {
                            if let jsonDict = item.dictionary //jsonDict : [String : JSON]?
                            {
                                //loop through all objects in this jsonDictionary
                                let postId = jsonDict["name"]?.stringValue
                                dictionary[postId!] = [jsonDict["value"]!.stringValue, jsonDict["unit"]!.stringValue]
                            }
                        }
                    
                    print(dictionary)
                   
                    let billboardConstraint = SCNBillboardConstraint()
                    billboardConstraint.freeAxes = SCNBillboardAxis.Y
                    
                    let textNode = SCNNode()
                    textNode.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
                    textNode.opacity = 0.0
                    self.sceneView.scene.rootNode.addChildNode(textNode)
                    textNode.position = worldCoord
                    let backNode = SCNNode()
                    let plaque = SCNBox(width: 0.14, height: 0.1, length: 0.01, chamferRadius: 0.005)
                    plaque.firstMaterial?.diffuse.contents = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
                    backNode.geometry = plaque
                    backNode.position.y += 0.09
                    
                    
                    
                    //Set up card view
                    let imageView = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 600))
                    imageView.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
                    imageView.alpha = 1.0
                    imageView.layer.cornerRadius = 15
                    let titleLabel = UILabel(frame: CGRect(x: 8, y: 64, width: imageView.frame.width, height: 100))
                    titleLabel.textAlignment = .left
                    titleLabel.numberOfLines = 1
                    titleLabel.font = UIFont(name: "Avenir", size: 84)
                    titleLabel.text = result.itemName.capitalized
                    titleLabel.textColor = .white
                    titleLabel.backgroundColor = .clear
                    imageView.addSubview(titleLabel)
                    
                    
                    
                    let lastTakenLabel = UILabel(frame: CGRect(x: 0, y: 0, width: imageView.frame.width-128, height: 42))
                    lastTakenLabel.textAlignment = .left
                    lastTakenLabel.numberOfLines = 1
                    lastTakenLabel.font = UIFont(name: "Avenir-HeavyOblique", size: 42)
                    //lastTakenLabel.text = "Last taken \(lastTakenTime.timestringFromNow()))"
                    lastTakenLabel.backgroundColor = .clear
                    lastTakenLabel.textColor = .white
                    
                    var sum = 0.0
                    
                    let proteinLine = UIView()
                    proteinLine.frame = CGRect(x:0,y:260, width: ((imageView.frame.width-20) / 3), height : 200)
                    let dropP = UIView()
                    dropP.frame = CGRect(x:0,y:260, width: ((imageView.frame.width-20) / 3), height : 200)
                    dropP.layer.cornerRadius = 10
                    dropP.clipsToBounds = true
                    dropP.layer.borderWidth = 2
                    dropP.layer.borderColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0).cgColor
                    dropP.backgroundColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:0.0)

                    proteinLine.backgroundColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
                    proteinLine.layer.cornerRadius = 10
                    proteinLine.clipsToBounds = true
                    proteinLine.layer.borderWidth = 1
                    proteinLine.layer.borderColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0).cgColor
                    let proteinLabel = UILabel()
                    proteinLabel.frame.size = CGSize(width: proteinLine.frame.width, height: 100)
                    proteinLabel.center = proteinLine.center
                    proteinLabel.textAlignment = .center
                    proteinLabel.numberOfLines = 0
                    proteinLabel.font = UIFont(name: "Avenir", size: 25)
                    let pGrams = dictionary["Protein"]![0] as! String
                    let pUnits = dictionary["Protein"]![1] as! String
                    proteinLabel.text = "Protein\n" + String(describing : pGrams) + pUnits
                    proteinLabel.textColor = .white
                    proteinLabel.backgroundColor = .clear
                    imageView.addSubview(dropP)
                    imageView.addSubview(proteinLine)
                    imageView.addSubview(proteinLabel)
                    
                    let carbLine = UIView()
                    carbLine.frame = CGRect(x:((imageView.frame.width-20) / 3) + 10,y:260, width: ((imageView.frame.width-20) / 3), height : 200)
                    carbLine.backgroundColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
                    carbLine.layer.cornerRadius = 10
                    carbLine.clipsToBounds = true
                    carbLine.layer.borderWidth = 2
                    carbLine.layer.borderColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0).cgColor
                    let dropC = UIView()
                    dropC.frame = CGRect(x:((imageView.frame.width-20) / 3) + 10,y:260, width: ((imageView.frame.width-20) / 3), height : 200)
                    dropC.layer.cornerRadius = 10
                    dropC.clipsToBounds = true
                    dropC.layer.borderWidth = 1
                    dropC.layer.borderColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0).cgColor
                    dropC.backgroundColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:0.0)
                    let cLabel = UILabel()
                    cLabel.frame.size = CGSize(width: carbLine.frame.width, height: 100)

                    cLabel.center = carbLine.center
                    cLabel.textAlignment = .center
                    cLabel.numberOfLines = 0
                    cLabel.font = UIFont(name: "Avenir", size: 25)
                    let cGrams = dictionary["Carbohydrate, by difference"]![0] as! String
                    let cUnits = dictionary["Carbohydrate, by difference"]![1] as! String
                    cLabel.text = "Carbs\n" + String(describing : cGrams) + cUnits
                    cLabel.textColor = .white
                    cLabel.backgroundColor = .clear
                    imageView.addSubview(carbLine)
                    imageView.addSubview(dropC)
                    imageView.addSubview(cLabel)

                    let fatLine = UIView()
                    fatLine.frame = CGRect(x: ((imageView.frame.width-20) / 3) + 20 + ((imageView.frame.width-20) / 3),y:260, width: ((imageView.frame.width-20) / 3), height : 200)
                    fatLine.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
                    fatLine.layer.cornerRadius = 10
                    fatLine.clipsToBounds = true
                    fatLine.layer.borderWidth = 2
                    fatLine.layer.borderColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0).cgColor
                    
                    let dropF = UIView()
                    dropF.frame = CGRect(x: ((imageView.frame.width-20) / 3) + 20 + ((imageView.frame.width-20) / 3),y:260, width: ((imageView.frame.width-20) / 3), height : 200)
                    dropF.layer.cornerRadius = 10
                    dropF.clipsToBounds = true
                    dropF.layer.borderWidth = 1
                    dropF.layer.borderColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0).cgColor
                    dropF.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:0.0)
                    let fLabel = UILabel()
                    fLabel.frame.size = CGSize(width: fatLine.frame.width, height: 100)
                    fLabel.center = fatLine.center
                    fLabel.textAlignment = .center
                    fLabel.numberOfLines = 0
                    fLabel.font = UIFont(name: "Avenir", size: 25)
                    let fGrams = dictionary["Total lipid (fat)"]![0] as! String
                    let fUnits = dictionary["Total lipid (fat)"]![1] as! String
                    fLabel.text = "Fat\n" + String(describing : fGrams) + fUnits
                    fLabel.textColor = .white
                    fLabel.backgroundColor = .clear
                    imageView.addSubview(dropF)
                    imageView.addSubview(fatLine)
                    imageView.addSubview(fLabel)

                    
                    
                    let pValueRel = Double(pGrams)! / 56
                    let cValueRel = Double(cGrams)! / 310
                    let fValueRel = Double(fGrams)! / 70
                    
                    sum = pValueRel + cValueRel + fValueRel
                    let pAverage = pValueRel / sum;
                    let cAverage = cValueRel / sum;
                    let fAverage = fValueRel / sum;
                    
                    let p = proteinLine.frame.size.height - proteinLine.frame.size.height * CGFloat(pAverage)
                    let c = carbLine.frame.size.height - carbLine.frame.size.height * CGFloat(cAverage)
                    let f = fatLine.frame.size.height - fatLine.frame.size.height * CGFloat(fAverage)
                   
                    proteinLine.frame = CGRect(x: proteinLine.frame.minX, y: proteinLine.frame.minY + p, width: proteinLine.frame.size.width, height: proteinLine.frame.size.height - p)
                    carbLine.frame = CGRect(x: carbLine.frame.minX, y: carbLine.frame.minY + c, width: carbLine.frame.size.width, height: carbLine.frame.size.height - c)
                    fatLine.frame = CGRect(x: fatLine.frame.minX, y: fatLine.frame.minY + f, width: fatLine.frame.size.width, height: fatLine.frame.size.height - f)
                    
                    print("Should be \(dictionary["Energy"]!) Calories");
                    let limitLabel = UILabel(frame: CGRect(x: 64, y: 200, width: imageView.frame.width-128, height: 63))
                    limitLabel.textAlignment = .center
                    limitLabel.numberOfLines = 1
                    limitLabel.textColor = .white
                    limitLabel.font = UIFont(name: "Avenir", size: 35)
                    limitLabel.text = "\(dictionary["Energy"]![0]) Calories"
                    limitLabel.backgroundColor = .clear
                    imageView.addSubview(limitLabel)
                    
                    let refillLabel = UILabel(frame: CGRect(x: 64, y: 365, width: imageView.frame.width-128, height: 42))
                    refillLabel.textAlignment = .center
                    refillLabel.numberOfLines = 1
                    refillLabel.font = UIFont(name: "Avenir", size: 42)
                    refillLabel.text = "REFILL SOON"
                    refillLabel.backgroundColor = .clear
                    refillLabel.textColor = .red
                    
                    
                    let buttonNode = self.createButton(size: CGSize(width: imageView.frame.width - 128, height: 84))
                    let b = JSON([dictionary]).rawString()!
                    print(b)
                    buttonNode.name = result.itemName + "C==3\(b)"
                    
                    self.buttons.append(buttonNode)
                    
                    let texture = UIImage.imageWithView(view: imageView)
                    
                    let infoNode = SCNNode()
                    let infoGeometry = SCNPlane(width: 0.13, height: 0.09)
                    infoGeometry.firstMaterial?.diffuse.contents = texture
                    infoNode.geometry = infoGeometry
                    infoNode.position.y += 0.09
                    infoNode.position.z += 0.0055
                    
                    textNode.addChildNode(backNode)
                    textNode.addChildNode(infoNode)
                    
                    infoNode.addChildNode(buttonNode)
                    buttonNode.position = infoNode.position
                    buttonNode.position.y -= (0.125)
                    
                    textNode.constraints = [billboardConstraint]
                    textNode.runAction(SCNAction.scale(to: 0.0, duration: 0))
                    backNode.runAction(SCNAction.scale(to: 0.0, duration: 0))
                    infoNode.runAction(SCNAction.scale(to: 0.0, duration: 0))
                    textNode.runAction(SCNAction.fadeOpacity(to: 0.0, duration: 0))
                    backNode.runAction(SCNAction.fadeOpacity(to: 0.0, duration: 0))
                    infoNode.runAction(SCNAction.fadeOpacity(to: 0.0, duration: 0))
                    
                    textNode.runAction(SCNAction.wait(duration: 0.01))
                    backNode.runAction(SCNAction.wait(duration: 0.01))
                    infoNode.runAction(SCNAction.wait(duration: 0.01))
                    textNode.runAction(SCNAction.scale(to: 1.0, duration: 0.3) )
                    backNode.runAction(SCNAction.scale(to: 1.0, duration: 0.3) )
                    infoNode.runAction(SCNAction.scale(to: 1.0, duration: 0.3) )
                    textNode.runAction(SCNAction.fadeOpacity(to: 1.0, duration: 0.3))
                    backNode.runAction(SCNAction.fadeOpacity(to: 1.0, duration: 0.3))
                    infoNode.runAction(SCNAction.fadeOpacity(to: 1.0, duration: 0.3))
                    self.nutrition.append(infoNode)
                }
            })
        }
    }
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
extension ViewController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        /*if gestureRecognizer == tapGesture{
            if let mainHistoryVC = self.mainHistoryVC{
                return  mainHistoryVC.view.frame.contains(gestureRecognizer.location(in: self.view)) == false
            }
        } */
        return true
    }
    
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer){
        /*
        if let mainHistoryVC = self.mainHistoryVC{
            switch recognizer.state {
            case .began:
                print("Began sliding VC")
            case .changed:
                let translation = recognizer.translation(in: view).y
                mainHistoryVC.view.center.y += translation
                recognizer.setTranslation(CGPoint.zero, in: view)
            case .ended:
                if abs(recognizer.velocity(in: view).y) > 200{
                    if recognizer.velocity(in: view).y < -200{
                        toggle(state: .Visible)
                    }else if recognizer.velocity(in: view).y > 200{
                        toggle(state: .Hidden)
                    }
                }else{
                    if mainHistoryVC.view.center.y > self.view.frame.height / 2.0{
                        toggle(state: .Hidden)
                    }else{
                        toggle(state: .Visible)
                    }
                }
            default:
                break
            }
        }*/
    }
}
extension ViewController {
    
    func toggle(state: HistoryVisible){
        /*
        if let mainHistoryVC = self.mainHistoryVC {
            print("Animating History State Change")
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5.0, options: .curveEaseOut, animations: {
                
                if state == .Visible{
                    mainHistoryVC.view.frame = UIScreen.main.bounds
                }else if state == .Hidden{
                    mainHistoryVC.view.frame.origin.y = self.view.frame.height - self.historyYOffset
                }
            }, completion:{ (finished) in
                //NotificationCenter.default.post(name: toggleHistoryNotification, object: nil)
            })
            FoodManager.shared().historyState = state
        }*/
    }
    
    func toggleState(){
        if FoodManager.shared().historyState == .Visible{
            toggle(state: .Hidden)
        }else{
            toggle(state: .Visible)
        }
    }
    
    func createButton(size: CGSize) -> SCNNode {
        let buttonNode = SCNNode()
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        buttonView.backgroundColor = UIColor(red: 96/255, green: 143/255, blue: 238/255, alpha: 1.0) /* #608fee */
        buttonView.layer.cornerRadius = 48
        let buttonLabel = UILabel(frame: CGRect(x: 0, y: 0, width: buttonView.frame.width, height: buttonView.frame.height))
        buttonLabel.backgroundColor = .clear
        buttonLabel.textColor = .white
        buttonLabel.text = "Consume"
        buttonLabel.font = UIFont(name: "Avenir", size: 42)
        buttonLabel.textAlignment = .center
        buttonView.addSubview(buttonLabel)
        buttonNode.geometry = SCNBox(width: size.width / 6000, height: size.height / 6000, length: 0.002, chamferRadius: 0.0)
        //buttonNode.geometry = SCNPlane(width: size.width / 6000, height: size.height / 6000)
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIImage.imageWithView(view: buttonView)
        let blueMaterial = SCNMaterial()
        blueMaterial.diffuse.contents = UIColor(red: 96/255, green: 143/255, blue: 238/255, alpha: 1.0) /* #608fee */
        buttonNode.geometry?.materials = [textMaterial, blueMaterial, blueMaterial, blueMaterial, blueMaterial, blueMaterial]
        //buttonNode.position.y
        //buttonNode.position.x
        return buttonNode
    }
    
}
extension UIImage {
    
    func crop(to:CGSize) -> UIImage {
        guard let cgimage = self.cgImage else { return self }
        
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        
        let contextSize: CGSize = contextImage.size
        
        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height
        
        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height
        
        if to.width > to.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if to.width < to.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: .right)
        
        UIGraphicsBeginImageContextWithOptions(to, true, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resized!
    }
    
    func zoom(to scale: CGFloat) -> UIImage? {
        var sideLength: CGFloat = 0;
        let imageHeight = self.size.height
        let imageWidth = self.size.width
        
        if imageHeight > imageWidth {
            sideLength = imageWidth
        }
        else {
            sideLength = imageHeight
        }
        
        let size = CGSize(width: sideLength, height: sideLength)
        
        let x = (size.width / 2) - (size.width / (2 * scale))
        let y = (size.height / 2) - (size.width / (2 * scale))
        
        let cropRect = CGRect(x: x, y: y, width: size.width / scale, height: size.height / scale)
        if let imageRef = cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 1.0, orientation: imageOrientation)
        }
        
        return nil
    }
}


extension UIImage {
    class func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

