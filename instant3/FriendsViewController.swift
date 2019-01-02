//
//  FriendsViewController.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 7/21/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//
import UIKit
import Parse


class FriendsViewController: UIViewController {

    

    @IBOutlet weak var searchTableView: UITableView!

    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var users: [PFUser]?
    
    /*
     This is a local cache. It stores all the users this user is following.
     It is used to update the UI immediately upon user interaction, instead of waiting
     for a server response.
     */
    var followingUsers: [PFUser]? {
        didSet {
            /**
             the list of following users may be fetched after the tableView has displayed
             cells. In this case, we reload the data to reflect "following" status
             */
            searchTableView.reloadData()
        }
    }
    
    // the current parse query
    var query: PFQuery? {
        didSet {
            // whenever we assign a new query, cancel any previous requests
            oldValue?.cancel()
        }
    }
    
    // this view can be in two different states
    enum State {
        case defaultMode
        case searchMode
    }
    
    // whenever the state changes, perform one of the two queries and update the list
    var state: State = .defaultMode {
        didSet {
            switch (state) {
            case .defaultMode:
                query = ParseHelper.allUsers(updateList)
                
            case .searchMode:
                print("search mode")
                let searchText = searchBar?.text ?? ""
                query = ParseHelper.searchUsers(searchText, completionBlock:updateList)
            }
        }
    }
    
    // MARK: Update userlist
    
    /**
     Is called as the completion block of all queries.
     As soon as a query completes, this method updates the Table View.
     */
    func updateList(_ results: [PFObject]?, error: NSError?) {
        print("updating list")
        if let error = error {
            ErrorHandling.defaultErrorHandler(error)
        }
        
        self.users = results as? [PFUser] ?? []
        self.searchTableView.reloadData()
        
    }
    
    // MARK: View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        state = .defaultMode
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        // fill the cache of a user's followees
        ParseHelper.getFollowingUsersForUser(PFUser.currentUser()!) {
            (results: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            let relations = results ?? []
            // use map to extract the User from a Follow object
            self.followingUsers = relations.map {
                $0.objectForKey(ParseHelper.ParseFollowToUser) as! PFUser
            }
            
        }
    }
    
}

// MARK: TableView Data Source

extension FriendsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! FriendSearchTableViewCell
        
        let user = users![indexPath.row]
        cell.user = user
        
        if let followingUsers = followingUsers {
            // check if current user is already following displayed user
            // change button appereance based on result
            cell.canFollow = !followingUsers.contains(user)
        }
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: Searchbar Delegate

extension FriendsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        state = .searchMode
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        state = .defaultMode
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ParseHelper.searchUsers(searchText, completionBlock:updateList)
    }
    
}

// MARK: FriendSearchTableViewCell Delegate

extension FriendsViewController: FriendSearchTableViewCellDelegate {
    
    func cell(_ cell: FriendSearchTableViewCell, didSelectFollowUser user: PFUser) {
        ParseHelper.addFollowRelationshipFromUser(PFUser.currentUser()!, toUser: user)
        // update local cache
        followingUsers?.append(user)
    }
    
    func cell(_ cell: FriendSearchTableViewCell, didSelectUnfollowUser user: PFUser) {
        if let followingUsers = followingUsers {
            ParseHelper.removeFollowRelationshipFromUser(PFUser.currentUser()!, toUser: user)
            // update local cache
            self.followingUsers = followingUsers.filter({$0 != user})
        }
    }
    
}

// MARK: Style

extension FriendsViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
