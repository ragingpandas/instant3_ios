//
//  TabBarController.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 8/5/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import UIKit
import AVFoundation

class TabBarController: UITabBarController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var picker = UIImagePickerController()
    
    func shootPhoto() {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker = UIImagePickerController() //make a clean controller
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.showsCameraControls = false
            picker.delegate = self  //uncomment if you want to take multiple pictures.
            
            picker.cameraViewTransform = picker.cameraViewTransform.translatedBy(x: 0, y: 20)
            //customView stuff
            

            let currentTabController = self.parent as! UITabBarController
            currentTabController.present(picker,
                                  animated: true,
                                  completion: {
            })
            
        } else { //no camera found -- alert the user.
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //get the image from info
        UIImageWriteToSavedPhotosAlbum(chosenImage, self,nil, nil) //save to the photo library
    }
    func didShoot(_ overlayView:CustomCameraOverlayView) {
        picker.takePicture()
        //overlayView.cameraLabel.text = "Shot Photo"
        print("Shot Photo")
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
