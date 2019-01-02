//
//  FriendSearchTableViewCell.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 7/24/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import UIKit
import Parse

protocol FriendSearchTableViewCellDelegate: class {
    func cell(_ cell: FriendSearchTableViewCell, didSelectFollowUser user: PFUser)
    func cell(_ cell: FriendSearchTableViewCell, didSelectUnfollowUser user: PFUser)
}

class FriendSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var addFriendButton: UIButton!
    
    
    @IBOutlet weak var userPictureImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @NSManaged var imageFile: PFFile?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: FriendSearchTableViewCellDelegate?
    
    var user: PFUser? {
        didSet {
            usernameLabel.text = user?.username
//            userPictureImageView.image = ParseHelper.ParseUserProfilePicture
        }
    }
    
    var canFollow: Bool? = true {
        didSet {
            /*
             Change the state of the follow button based on whether or not
             it is possible to follow a user.
             */
            if let canFollow = canFollow {
                addFriendButton.isSelected = !canFollow
            }
        }
    }
    
    
    @IBAction func addFriend(_ sender: AnyObject) {
        if let canFollow = canFollow, canFollow == true {
            delegate?.cell(self, didSelectFollowUser: user!)
            self.canFollow = false
        } else {
            delegate?.cell(self, didSelectUnfollowUser: user!)
            self.canFollow = true
        }

    }
}
