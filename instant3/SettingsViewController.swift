//
//  SettingsViewController.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 7/21/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import Parse
import UIKit
import FBSDKCoreKit
import ParseUI
import ParseFacebookUtilsV4
import Toucan

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    var chosenImage: UIImage!

    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var addProfilePicture: UIButton!
    
    
//    var window: UIWindow?
//    var parseLoginHelper: ParseLoginHelper!
//    var startViewController: UIViewController
//
//    Parse.initializeWithConfiguration(configuration)
//    
//    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    @IBAction func logout(_ sender: AnyObject) {
        var parseLoginHelper: ParseLoginHelper!

        
        print("log pressed")
        PFUser.logOut()
        UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: nil)
        

    }

    @IBAction func unwindToSettingViewController(_ segue: UIStoryboardSegue) {
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismiss(animated: true) { (nil) in
            self.performSegue(withIdentifier: "toProfilePicConfirm", sender: self)
        }
        
        chosenImage = image
        print("sweeden")
    }

    
    @IBAction func addProfilePic(_ sender: AnyObject) {
        selectPicture()
    }
    func selectPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue!, sender: Any!) {
        if (segue.identifier == "toProfilePicConfirm") {
            let navVC = segue.destination as! UINavigationController
            
            let svc = navVC.viewControllers.first as! ConfirmPicViewController;
            
            if chosenImage != nil{
                print("not empty here")
            }else{
                print("empty")
            }
            
            svc.toPass = chosenImage
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = 5
        addProfilePicture.layer.cornerRadius = 5
//        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
//            // Initialize the ParseLoginHelper with a callback
//            if let error = error {
//                // 1
//                ErrorHandling.defaultErrorHandler(error)
//            } else  if let _ = user {
//                // if login was successful, display the TabBarController
//                // 2
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
//                // 3
//                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                
//                appDelegate.window?.rootViewController = tabBarController
//                appDelegate.window?.makeKeyAndVisible()
//                
//                
//                //                self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
//            }

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

