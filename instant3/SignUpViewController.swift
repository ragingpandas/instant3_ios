//
//  SignUpViewController.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 8/10/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import Parse
import ParseUI
import ParseFacebookUtilsV4


class SignUpViewController: PFSignUpViewController {

    var backgroundView : UIView!
    var parseLoginHelper: ParseLoginHelper?
    var window: UIWindow?


    
    override func viewDidLoad() {
        let logo = UILabel()
        logo.text = "Instant3"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "Pacifico", size: 70)
        logo.shadowColor = UIColor.lightGrayColor()
        logo.shadowOffset = CGSizeMake(2, 2)
        signUpView?.logo = logo
        super.viewDidLoad()
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 255/255, green: 113/255, blue: 0/255, alpha: 1.0) /* #ff7100 */
        self.signUpView!.insertSubview(backgroundView, atIndex: 0)

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        backgroundView.frame = CGRectMake( 0,  0,  self.signUpView!.frame.width,  self.signUpView!.frame.height)
        signUpView!.logo!.sizeToFit()
        let logoFrame = signUpView!.logo!.frame
        signUpView!.logo!.frame = CGRectMake(logoFrame.origin.x, signUpView!.usernameField!.frame.origin.y - logoFrame.height - 16, signUpView!.frame.width,  logoFrame.height)
       
        

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
