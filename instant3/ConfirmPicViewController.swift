//
//  ConfirmPicViewController.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 8/10/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import UIKit
import Toucan
import Parse

class ConfirmPicViewController: UIViewController {
    
    var toPass: UIImage!
    var newImage: UIImage!
    var currentUser: PFUser!
    
    @IBOutlet weak var oldImageView: UIImageView!
    
    @IBOutlet weak var newImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newImage = Toucan(image: toPass).maskWithEllipse().image
        currentUser = PFUser.currentUser()
        newImageView.image = newImage
        currentUser.refreshInBackgroundWithBlock { (object, error) -> Void in
// 2
            self.currentUser.fetchIfNeededInBackgroundWithBlock { (obj: PFObject?, error: NSError?) -> Void in
                if obj != nil {
                    var fetchedUser = obj as! PFUser
                    
                    if var oldImageFile = fetchedUser["profilePicture"]
                    {
                        oldImageFile.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in

                            self.oldImageView.image = UIImage(data: data!)
                        }
                    }
                }
                }
                
            
                    
                }
            print("currentImage Not nil")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addAction(_ sender: AnyObject) {
        currentUser = PFUser.currentUser()
        let imageThing = UIImagePNGRepresentation(toPass)
        let file = PFFile(data: imageThing!)
        currentUser!["profilePicture"] = file
        currentUser.saveInBackgroundWithBlock(nil)
        let pictureUpdated = UIAlertController(title: "Profile Picture Updated", message: "You have just chaned your profile picture.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{
            (_)in
            self.performSegue(withIdentifier: "unwindToSettings", sender: self)
        })
        
        pictureUpdated.addAction(ok)
        self.present(pictureUpdated, animated: true, completion: nil)

        currentUser.saveInBackground()
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
