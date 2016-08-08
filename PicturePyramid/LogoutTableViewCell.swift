//
//  LogoutTableViewCell.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 8/7/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import Parse
import UIKit
import FBSDKCoreKit
import ParseUI
import ParseFacebookUtilsV4

protocol LogoutTableViewCellDelegate: class {
    func cell(cell: LogoutTableViewCell)
}

class LogoutTableViewCell: UITableViewCell {
    
    
    weak var delegate: LogoutTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
extension LogoutTableViewCell: UIApplicationDelegate{
//    Parse.initializeWithConfiguration(configuration)
//    
//    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)

}
