//
//  PostPhotoViewController.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 7/21/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import UIKit
import AVFoundation

class PostPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var chosenImage: UIImage!
    var picker = UIImagePickerController()
//    
 
    @IBOutlet weak var cameraView: UIView!
    @IBAction func unwindToPostPhotoViewController(_ segue: UIStoryboardSegue) {
        
        
    }
    
    @IBAction func testing(_ sender: AnyObject) {
    }
    @IBOutlet weak var testing: UIButton!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        chosenImage = image
        self.dismiss(animated: true) { (nil) in
            self.performSegue(withIdentifier: "goToConfirm", sender: self)
        }
        
        
        print("finland")
    }
    
    @IBAction func hitUpload(_ sender: AnyObject) {
        selectPicture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        shootPhoto()
        previewLayer?.frame = cameraView.bounds
    }
    
    
    func selectPicture() {
        
        picker.allowsEditing = false
        picker.delegate = self
    
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue!, sender: Any!) {
        if (segue.identifier == "goToConfirm") {
            let navVC = segue.destination as! UINavigationController
            
            let svc = navVC.viewControllers.first as! confirmPostViewController;
            
            if chosenImage != nil{
                print("not empty here")
            }else{
                print("empty")
            }
            
            svc.toPass = chosenImage
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error : NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error == nil && captureSession?.canAddInput(input) != nil){
            
            captureSession?.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            
            if (captureSession?.canAddOutput(stillImageOutput) != nil){
                captureSession?.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                cameraView.layer.addSublayer(previewLayer!)
                captureSession?.startRunning()
                
            }
            
            
        }
        
    }
    func didPressTakePhoto() {
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) in
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    var dataProvider = CGDataProvider(data: imageData as! CFData)
//                    var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
//                    
//                    var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
//                    
//                    self.tempImageView.image = image
//                    self.tempImageView.hidden = false

                }
            })
        }
    }
    
//    func shootPhoto() {
//        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
//            picker = UIImagePickerController() //make a clean controller
//            
//            picker.allowsEditing = false
//            picker.sourceType = UIImagePickerControllerSourceType.Camera
//            picker.cameraCaptureMode = .Photo
//            picker.showsCameraControls = false
//            picker.delegate = self  //uncomment if you want to take multiple pictures.
//            picker.cameraViewTransform = CGAffineTransformTranslate(picker.cameraViewTransform, 0.0, 80.0)// shift down
//            picker.cameraViewTransform = CGAffineTransformMakeScale(1.5, 1.5)
//            
//            //customView stuff
//            let customViewController = CustomOverlayViewController(
//                nibName:"CustomOverlayViewController",
//                bundle: nil
//            )
//            let customView:CustomCameraOverlayView = customViewController.view as! CustomCameraOverlayView // CustomOverlayView
//            
//            customView.frame = self.picker.view.frame
//            ParseHelper.topHeight = customView.frame.height
//            //customView.cameraLabel.text = "Hello Cute Camera"
//            customView.delegate = self
//            
//            //presentation of the camera
//            picker.modalPresentationStyle = .FullScreen
//            
//            
//            presentViewController(picker,
//                                  animated: true,
//                                  completion: {
//                                    self.picker.cameraOverlayView = customView
//            })
//            
//        } else { //no camera found -- alert the user.
//            let alertVC = UIAlertController(
//                title: "No Camera",
//                message: "Sorry, this device has no camera",
//                preferredStyle: .Alert)
//            let okAction = UIAlertAction(
//                title: "OK",
//                style:.Default,
//                handler: nil)
//            alertVC.addAction(okAction)
//            presentViewController(
//                alertVC,
//                animated: true,
//                completion: nil)
//        }
//    }
//    //MARK: Custom View Delegates
//    func didCancel(overlayView:CustomCameraOverlayView) {
//        picker.dismissViewControllerAnimated(true,completion: nil)
//        print("dismissed!!")
//    }
//    func didShoot(overlayView:CustomCameraOverlayView) {
//        picker.takePicture()
//        //overlayView.cameraLabel.text = "Shot Photo"
//        print("Shot Photo")
//    }
    
}


