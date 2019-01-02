//
//  Post.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 7/26/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import Foundation

import Bond
import ConvenienceKit
import Parse


class Post : PFObject, PFSubclassing {
    
    private lazy var __once: () = {
            self.registerSubclass()
        }()
    
    @NSManaged var imageFile: PFFile?
//    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    static var imageCache: NSCacheSwift<String, UIImage>!
    
    var imagePulled: Observable<UIImage?> = Observable(nil)
    
    var photoUploadTask: UIBackgroundTaskIdentifier?

    var image: Observable<UIImage?> = Observable(nil)

    static func parseClassName() -> String {
        return "Post"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : Int = 0;
        _ = self.__once
    }
    func flagPost(_ user: PFUser) {
        ParseHelper.flagPost(user, post: self)
    }

    func uploadPost() {
        if let image = image.value {
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
    func downloadImage(_ onComplete: ((UIImage) -> Void)?) {
        // if image is not downloaded yet, get it
        // 1
        if (image.value == nil) {
            // 2
            imageFile?.getDataInBackgroundWithBlock { (data: Data?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    // 3
                    self.image.value = image
                    
                    if let onComplete = onComplete {
                        onComplete(image)
                    }
                }
            }
        }
    }
}
