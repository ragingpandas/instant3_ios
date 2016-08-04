//
//  KolodaPost.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 8/3/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import UIKit
import Parse

protocol KolodaPostDelegate {
    func didGetImage(postImage: KolodaPostImage) -> Void
}

struct KolodaPostImage {
    let post: KolodaPost
    let image: UIImage
}

class KolodaPost {
    var posts = [Post]()
    
    var postImages: [KolodaPostImage] {
        var images = [KolodaPostImage]()
        
        for post in posts {
            images.append(KolodaPostImage(post: self, image: post.image.value!))
        }
        
        return images
    }
    
    var followerIndex: Int
    
    var delegate: KolodaPostDelegate!
    
    init(followerIndex: Int) {
        self.followerIndex = followerIndex
    }
    
    func getPostsFromParse() {
        ParseHelper.timelineRequestForCurrentUser(followerIndex: self.followerIndex) { result, error in
            let posts = result as? [Post] ?? []
            
            self.posts = posts
            
            for post in self.posts {
                post.downloadImage { image in
                    let postImage = KolodaPostImage(post: self, image: image)
                    self.delegate.didGetImage(postImage)
                }
            }
        }
    }
}