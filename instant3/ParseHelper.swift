//
//  ParseHelper.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 7/24/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    static var topHeight: CGFloat!
    static let ParseFollowClass       = "follow"
    static let ParseFollowFromUser    = "fromUser"
    static let ParseFollowToUser      = "toUser"
    static let ParseUserUsername      = "username"
    static let ParseUserProfilePicture = "profilePicture"
    static let ParseFlaggedContentClass    = "FlaggedContent"
    static let ParseFlaggedContentFromUser = "fromUser"
    static let ParseFlaggedContentToPost   = "toPost"
    
    static var posts1: [Post] = []
    static var posts2: [Post] = []
    static var posts3: [Post] = []

    
    /**
     Establishes a follow relationship between two users.
     
     :param: user    The user that is following
     :param: toUser  The user that is being followed
     */
    
    // MARK: Users
    
    /**
     Fetch all users, except the one that's currently signed in.
     Limits the amount of users returned to 20.
     
     :param: completionBlock The completion block that is called when the query completes
     
     :returns: The generated PFQuery
     */
    static func allUsers(_ completionBlock: PFQueryArrayResultBlock) -> PFQuery {
        let query = PFUser.query()!
        // exclude the current user
        query.whereKey(ParseHelper.ParseUserUsername,
                       notEqualTo: PFUser.currentUser()!.username!)
        query.orderByAscending(ParseHelper.ParseUserUsername)
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
    }
    
    /**
     Fetch users whose usernames match the provided search term.
     
     :param: searchText The text that should be used to search for users
     :param: completionBlock The completion block that is called when the query completes
     
     :returns: The generated PFQuery
     */
    static func searchUsers(_ searchText: String, completionBlock: PFQueryArrayResultBlock)
        -> PFQuery {
            /*
             NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
             Regex can be slow on large datasets. For large amount of data it's better to store
             lowercased username in a separate column and perform a regular string compare.
             */
            let query = PFUser.query()!.whereKey(ParseHelper.ParseUserUsername,
                                                 matchesRegex: searchText, modifiers: "i")
            
            query.whereKey(ParseHelper.ParseUserUsername,
                           notEqualTo: PFUser.currentUser()!.username!)
            
            query.orderByAscending(ParseHelper.ParseUserUsername)
            query.limit = 20
            
            query.findObjectsInBackgroundWithBlock(completionBlock)
            
            return query
    }
    

    static func findFollowing(_ completion: () -> ()) -> [PFUser] {
        var userArray: [PFUser] = [PFUser]()

        let query = PFQuery(className: ParseFollowClass)
        query.whereKey(ParseFollowToUser, equalTo: PFUser.currentUser()!)
        print(PFUser.currentUser()) 
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let objects = objects {
                for users in objects{
                    userArray.append(users.objectForKey("fromUser") as! PFUser)
           
                }
            }
            print(userArray)
            confirmPostViewController.finishedGettingFollowers(userArray)
            completion()
        }
        
        return userArray
        
    }
    
    static func timelineRequestForCurrentUser(followerIndex: Int, completionBlock: PFQueryArrayResultBlock) {
        let followingQuery = PFQuery(className: "follow")
        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        
        // 2
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey("follower\(followerIndex)", equalTo: PFUser.currentUser()!)
        //        let followerQuery = Post.query()
        postsFromFollowedUsers!.whereKey("follower\(followerIndex)HasSeen", equalTo: false)
        postsFromFollowedUsers!.includeKey("likes")
        postsFromFollowedUsers!.includeKey("user")
        //        let query = PFQuery.orQueryWithSubqueries([followerQuery!, postsFromFollowedUsers!])
        postsFromFollowedUsers!.findObjectsInBackgroundWithBlock(completionBlock)
    }

    /**
     Fetch users whose usernames match the provided search term.
     
     :param: searchText The text that should be used to search for users
     :param: completionBlock The completion block that is called when the query completes
     
     :returns: The generated PFQuery
     */
//    static func pullFromFeed1(completion: ()) {
//        let followingQuery = PFQuery(className: ParseFollowClass)
//        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
//        let postsFromFollowedUsers1 = Post.query()
//        postsFromFollowedUsers1!.whereKey("user", matchesKey: "follower1", inQuery: followingQuery)
//        postsFromFollowedUsers1!.whereKey("false", matchesKey: "follower1HasSeen", inQuery: followingQuery)
//        
//        postsFromFollowedUsers1!.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
//            if let objects = objects {
//                for post in objects{
//                    posts1.append(post.objectForKey("follower1") as! Post)
//                    
//                }
//            }
//            completion
//        }
//    }
//     static func pullFromFeed2(completion: ()){
//        let followingQuery = PFQuery(className: ParseFollowClass)
//        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
//        let postsFromFollowedUsers2 = Post.query()
//        postsFromFollowedUsers2!.whereKey("user", matchesKey: "follower2", inQuery: followingQuery)
//        postsFromFollowedUsers2!.whereKey("false", matchesKey: "follower2HasSeen", inQuery: followingQuery)
//        
//        postsFromFollowedUsers2!.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
//            if let objects = objects {
//                for post in objects{
//                    posts2.append(post.objectForKey("follower2") as! Post)
//                    
//                }
//            }
//            completion
//        }
//        
//    }
//    static func pullFromFeed3(completion: ()){
//        let followingQuery = PFQuery(className: ParseFollowClass)
//        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
//        let postsFromFollowedUsers3 = Post.query()
//        postsFromFollowedUsers3!.whereKey("user", matchesKey: "follower3", inQuery: followingQuery)
//        postsFromFollowedUsers3!.whereKey("false", matchesKey: "follower3HasSeen", inQuery: followingQuery)
//        
//        postsFromFollowedUsers3!.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
//            if let objects = objects {
//                for post in objects{
//                    posts3.append(post.objectForKey("follower3") as! Post)
//                    
//                }
//            }
//            completion
//        }
//    }
//    static func returnPosts1()->[Post]{
//        return posts1
//    }
//    static func returnPosts2()->[Post]{
//        return posts2
//    }
//    static func returnPosts3()->[Post]{
//        return posts3
//    }
    
    static func getFollowingUsersForUser(_ user: PFUser, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: ParseFollowClass)
        
        query.whereKey(ParseFollowFromUser, equalTo:user)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    static func flagPost(_ user: PFUser, post: Post) {
        let flagObject = PFObject(className: ParseFlaggedContentClass)
        flagObject.setObject(user, forKey: ParseFlaggedContentFromUser)
        flagObject.setObject(post, forKey: ParseFlaggedContentToPost)
        
        let ACL = PFACL(user: PFUser.currentUser()!)
        ACL.publicReadAccess = true
        flagObject.ACL = ACL
        
        //TODO: add error handling
        flagObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
    }
    
    /**
     Establishes a follow relationship between two users.
     
     :param: user    The user that is following
     :param: toUser  The user that is being followed
     */
    static func addFollowRelationshipFromUser(_ user: PFUser, toUser: PFUser) {
        let followObject = PFObject(className: ParseFollowClass)
        followObject.setObject(user, forKey: ParseFollowFromUser)
        followObject.setObject(toUser, forKey: ParseFollowToUser)
        
        followObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
    }
    
    /**
     Deletes a follow relationship between two users.
     
     :param: user    The user that is following
     :param: toUser  The user that is being followed
     */
    static func removeFollowRelationshipFromUser(_ user: PFUser, toUser: PFUser) {
        let query = PFQuery(className: ParseFollowClass)
        query.whereKey(ParseFollowFromUser, equalTo:user)
        query.whereKey(ParseFollowToUser, equalTo: toUser)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            
            let results = results ?? []
            
            for follow in results {
                follow.deleteInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
            }
        }
    }


}
extension PFObject {
    
    public override func isEqual(_ object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
    
}
