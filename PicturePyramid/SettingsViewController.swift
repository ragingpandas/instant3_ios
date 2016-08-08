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

class SettingsViewController: UIViewController{

//    var window: UIWindow?
//    var parseLoginHelper: ParseLoginHelper!
//    var startViewController: UIViewController
//
//    Parse.initializeWithConfiguration(configuration)
//    
//    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
//
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
//        let loginViewController = PFLogInViewController()
//        loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .Facebook]
//        loginViewController.delegate = parseLoginHelper
//        loginViewController.signUpController?.delegate = parseLoginHelper
//        
//        startViewController = loginViewController
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.window?.rootViewController = startViewController;
//        self.window?.makeKeyAndVisible()
//        
//        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

