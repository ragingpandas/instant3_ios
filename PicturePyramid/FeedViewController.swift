//
//  FeedViewController.swift
//  PicturePyramid
//
//  Created by Bassil Shama on 7/21/16.
//  Copyright © 2016 Bassil Shama. All rights reserved.
//

import UIKit
import Koloda
import Parse
import pop

private var numberOfCards: UInt = 1
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 1
private let kolodaAlphaValueSemiTransparent: CGFloat = 0
var post1Index = -1
var post2Index = -1
var post3Index = -1

class FeedViewController: UIViewController {
    var posts: [Post] = []


//    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidAppear(animated: Bool) {
//        ParseHelper.timelineRequestForCurrentUser{
//            (result: [PFObject]?, error: NSError?) -> Void in
//            self.posts = result as? [Post] ?? []
//        }
    }
    override func viewDidLoad() {
//        ParseHelper.pullFromFeed1(post1Done())
//        ParseHelper.pullFromFeed2(post2Done())
//        ParseHelper.pullFromFeed3(post3Done())
        
        super.viewDidLoad()
//        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
//        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
//        kolodaView.delegate = self
//        kolodaView.dataSource = self
//        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        print("view loaded")
    }

    @IBAction func leftButtonTapped(sender: AnyObject) {
//        kolodaView?.swipe(SwipeResultDirection.Left)

    }
    
    
    @IBAction func rightButtonTapped(sender: AnyObject) {
//        kolodaView?.swipe(SwipeResultDirection.Right)

    }
    
    
    
    

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
//    func post1Done(){
//        postArray1 = ParseHelper.returnPosts1()
//    }
//    func post2Done(){
//        postArray2 = ParseHelper.returnPosts2()
//    }
//    func post3Done(){
//        postArray3 = ParseHelper.returnPosts3()
//    }

}
//MARK: KolodaViewDelegate
extension FeedViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        print("run out of cards")
//        dataSource.insert(UIImage(named: "Card_like_6")!, atIndex: kolodaView.currentCardIndex - 1)
//        let position = kolodaView.currentCardIndex
//        kolodaView.insertCardAtIndexRange(position...position, animated: true)
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
//        let imageView = sender.view as! UIImageView
//        let newImageView = UIImageView(image: imageView.image)
//        newImageView.frame = self.view.frame
//        newImageView.backgroundColor = .blackColor()
//        newImageView.contentMode = .ScaleAspectFit
//        newImageView.userInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: "dismissFullscreenImage:")
//        newImageView.addGestureRecognizer(tap)
//        self.view.addSubview(newImageView)
    }
//    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
//        sender.view?.removeFromSuperview()
//    }
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        
        return animation
    }
}

//MARK: KolodaViewDataSource
extension FeedViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        print("number of cards")
        return UInt(posts.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        post1Index += 1
        print("posts incoming")
        print(posts)
        return UIImageView(posts[post1Index].downloadImage(nil))
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
 func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        // Change index to Int because literally no one uses UInt
        let index = Int(index)
        
        switch direction.rawValue {
        case "Left" :

            break
            
        case "Right" :

            break
            
        default :
            print("Not a valid direction.")
            break
        }
    }

}

