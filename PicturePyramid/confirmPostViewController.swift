//
//  confirmPostViewController.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 7/23/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import UIKit

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
