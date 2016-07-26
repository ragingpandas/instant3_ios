//
//  confirmPostViewController.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 7/23/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import UIKit
import Parse
import Foundation
import Bond
import Darwin

class confirmPostViewController: UIViewController {
    var toPass: UIImage!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("made it to check")
        if toPass != nil{
            print("image is here")
        }
        imageView.image = toPass

                // Do any additional setup after loading the view.
    }
    
    
    @IBAction func postButton(sender: AnyObject) {
        let found = ParseHelper.findFollowing()
        let numberOfFollowers = found.countObjects(nil)
        if numberOfFollowers > 4{
            let post = Post()
            post.image = toPass
            post["user"] = PFUser.currentUser()
            post["passedOn"] = 0
            post["likes"] = 0
            post["sentFrom"] = PFUser.currentUser()
            let follower1Int = Int(arc4random_uniform(UInt32(numberOfFollowers)))
            var follower2Int = Int(arc4random_uniform(UInt32(numberOfFollowers)))
            if follower2Int == follower1Int{
                while follower2Int == follower1Int{
                    follower2Int = Int(arc4random_uniform(UInt32(numberOfFollowers)))
                }
            }
            var follower3Int = Int(arc4random_uniform(UInt32(numberOfFollowers)))
            if follower3Int == follower2Int || follower3Int == follower1Int{
                while follower3Int == follower2Int || follower3Int == follower1Int{
                    follower3Int = Int(arc4random_uniform(UInt32(numberOfFollowers)))
                }
            }
            post.uploadPost()
            
        }
    }
    
    

    @IBOutlet weak var imageView: UIImageView!
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

