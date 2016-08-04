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
    var found: [PFUser] = []
    static var foundFollowers: [PFUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("made it to check")
        if toPass != nil{
            print("image is here")
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        imageView.image = toPass

                // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBAction func postButton(sender: AnyObject) {
        print("Post Button Hit")
        

        found = ParseHelper.findFollowing(arrayDone)
        
        
        print(found)
    }
    func arrayDone(){
        found = confirmPostViewController.foundFollowers

        let numberOfFollowers = found.count
        
        
        print(numberOfFollowers)
        if numberOfFollowers > 4{
            let post = Post()
            let likesClass = PFObject(className: "likes")
            likesClass["numberOfLikes"] = 0
            likesClass.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                post["likes"] = likesClass
            }

            post["user"] = PFUser.currentUser()
            post["passedOn"] = 0
            
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
            post["follower1"] = found[follower1Int]
            post["follower2"] = found[follower2Int]
            post["follower3"] = found[follower3Int]
            post["follower1HasSeen"] = false
            post["follower2HasSeen"] = false
            post["follower3HasSeen"] = false
            
            
            let currentDate = NSDate()
            
            let currentDateComponents = NSDateComponents()
            
            currentDateComponents.timeZone = NSTimeZone(abbreviation: "GMT")
            
            var hoursToAdd: Int = 0
            var minutesToAdd: Int = 0
            
            if numberOfFollowers < 11{
                
                minutesToAdd = 0
                hoursToAdd = 24
                
            }else if numberOfFollowers < 26{
                
                minutesToAdd = 0
                hoursToAdd = 12
                
            }else if numberOfFollowers < 51{
                
                minutesToAdd = 0
                hoursToAdd = 6
                
            }else if numberOfFollowers < 101{
                
                minutesToAdd = 0
                hoursToAdd = 2
                
            }else if numberOfFollowers < 251{
                
                hoursToAdd = 1
                
            }else if numberOfFollowers < 501{
                
                minutesToAdd = 30
                
            }else{
                
                minutesToAdd = 15
                
            }
            
            
            currentDateComponents.hour = hoursToAdd
            currentDateComponents.minute = minutesToAdd
            
            let calculatedDate = NSCalendar.currentCalendar().dateByAddingComponents(currentDateComponents, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
            
            post["follower1Expire"] = calculatedDate
            post["follower2Expire"] = calculatedDate
            post["follower3Expire"] = calculatedDate
            var title = titleTextField.text
            if title == ""{
                title = "No Title"
            }
            
            post["title"] = title
            
            post.image.value = toPass
            print("before upload post")
            post.uploadPost()
            self.performSegueWithIdentifier("sharePostUnwind", sender: self)
            
            print("after upload post")
        }else{
            let notEnoughFollowers = UIAlertController(title: "Not Enough Followers!", message: "You need at least 5 followers to post something!", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{
                (_)in
                self.performSegueWithIdentifier("sharePostUnwind", sender: self)
            })
            
            notEnoughFollowers.addAction(ok)
            self.presentViewController(notEnoughFollowers, animated: true, completion: nil)
            
        }

    }
    
    

    @IBOutlet weak var imageView: UIImageView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    class func finishedGettingFollowers (followers: [PFUser]) {
        print("finishedGettingFollowers: \(followers)")
        confirmPostViewController.foundFollowers = followers
    }

}

