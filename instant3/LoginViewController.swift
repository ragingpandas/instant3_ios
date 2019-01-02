//
//  LoginViewController.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 8/9/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//
import Parse
import ParseUI
import ParseFacebookUtilsV4


class LoginViewController : PFLogInViewController {
    
    var backgroundView : UIView!;

    var parseLoginHelper: ParseLoginHelper?
    
    override func viewDidLoad() {
        fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .Facebook]
        
        super.viewDidLoad()
        
        let logo = UILabel()
        logo.text = "Instant3"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "Pacifico", size: 70)
        logo.shadowColor = UIColor.lightGrayColor()
        logo.shadowOffset = CGSizeMake(2, 2)
        logInView?.logo = logo
        
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 255/255, green: 113/255, blue: 0/255, alpha: 1.0) /* #ff7100 */

        self.logInView!.insertSubview(backgroundView, atIndex: 0)
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
 

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        backgroundView.frame = CGRectMake( 0,  0,  self.logInView!.frame.width,  self.logInView!.frame.height)
        logInView!.logo!.sizeToFit()
        let logoFrame = logInView!.logo!.frame
        logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.currentUser() != nil) {
            parseLoginHelper!.callback(PFUser.currentUser()!, nil)
        }
    }
    
}
//extension PFSignUpViewController{
//    
//}
