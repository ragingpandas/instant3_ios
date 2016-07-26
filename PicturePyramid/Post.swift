//
//  Post.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 7/26/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import Foundation
import Parse


class Post : PFObject, PFSubclassing {
    
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    var photoUploadTask: UIBackgroundTaskIdentifier?

    var image: UIImage?
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    func uploadPost() {
        if let image = image {
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
            
            self.imageFile = imageFile
            saveInBackgroundWithBlock(nil)
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
        }
    }
    
}