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
    func didGetImage(_ postImage: KolodaPostImage) -> Void
}

struct KolodaPostImage {
    let kolodaPost: KolodaPost
    let post: Post
    let image: UIImage
}

class KolodaPost {
    var posts = [Post]()
    
    var postImages: [KolodaPostImage] {
        var images = [KolodaPostImage]()
        
        for post in posts {
            images.append(KolodaPostImage(kolodaPost: self, post: post, image: post.image.value!))
        }
        
        return images
    }
    
    var followerIndex: Int
    
    var delegate: KolodaPostDelegate!
    
    init(followerIndex: Int) {
        self.followerIndex = followerIndex
    }
    
    func getPostsFromParse(_ completion: @escaping () -> Void) {
        ParseHelper.timelineRequestForCurrentUser(followerIndex: self.followerIndex) { result, error in
            let posts = result as? [Post] ?? []
            
            self.posts = posts
            
            for post in self.posts {
                post.downloadImage { image in
                    let postImage = KolodaPostImage(kolodaPost: self, post: post, image: image)
                    self.delegate.didGetImage(postImage)
                }
            }
            completion()
        }
    }
}
