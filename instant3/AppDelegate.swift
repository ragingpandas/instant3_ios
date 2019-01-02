//
//  AppDelegate.swift
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var parseLoginHelper: ParseLoginHelper!
    var photoUploadTask: UIBackgroundTaskIdentifier?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Set up the Parse SDK
        let configuration = ParseClientConfiguration {
            $0.applicationId = "socialPyramid"
            $0.server = "https://social-pyramid.herokuapp.com/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // check if we have logged in user
        // 2
        let user = PFUser.currentUser()
        
        let startViewController: UIViewController
        
            // 3
            // if we have a user, set the TabBarController to be the initial view controller
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            startViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as!
        
        
        //        } else {
        // 4
        // Otherwise set the LoginViewController to be the first
        let loginViewController: LoginViewController
        loginViewController = LoginViewController()
        
        loginViewController.signUpController = SignUpViewController()
        
        loginViewController.delegate = parseLoginHelper
        loginViewController.signUpController?.delegate = parseLoginHelper
        
        loginViewController.parseLoginHelper = parseLoginHelper
        startViewController = loginViewController
        
        
        // Email as username
        loginViewController.emailAsUsername = false
        loginViewController.signUpController?.emailAsUsername = false

        
//        }
        
        // 5
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = startViewController;
        self.window?.makeKeyAndVisible()

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    
    override init() {
        super.init()
        
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let _ = user {
                // if login was successful, display the TabBarController
                // 2

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
                self.window?.rootViewController!.presentViewController(tabBarController, animated: true, completion: nil)
//                self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
                                       
                

            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

