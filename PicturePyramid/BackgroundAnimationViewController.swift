import UIKit
import Koloda
import pop
import Parse
import SwiftSpinner

private var numberOfCards: UInt = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 1
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class BackgroundAnimationViewController: UIViewController {
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var usernameView: UILabel!
    
    @IBOutlet weak var likesView: UILabel!
    
    @IBOutlet weak var ageView: UILabel!
    
    @IBOutlet weak var profilePickView: UIImageView!
    
    @IBOutlet weak var reloadView: UIView!
    
    @IBOutlet weak var userInfoView: UIView!
    
    var kolodaPosts = [KolodaPost]()
    var kolodaPostsImages = [KolodaPostImage]()
    
    var found = [PFUser]()
    
    var currentArray = 1
    var returnedImage: UIImage?
    
    var newPost: Post!
    static var foundFollowers = [PFUser]()

    var returnImage: UIImage!
    var currentIndexReturn: Int = 0
    //MARK: Lifecycle

    override func viewDidLoad() {
        
        kolodaView.userInteractionEnabled = false
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        for followerIndex in 1..<4 {
            let kolodaPost = KolodaPost(followerIndex: followerIndex)
            kolodaPosts.append(kolodaPost)
            kolodaPost.delegate = self
            kolodaPost.getPostsFromParse(update())
        }
        
        
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        print("left tapped")
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        print("right tapped")
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    

    @IBAction func unwindToBackgroundAnimationController(segue: UIStoryboardSegue) {
        
    }
    
   
    @IBAction func reloadPressed(sender: AnyObject) {
        SwiftSpinner.show("Finding more posts")
        for followerIndex in 1..<4 {
            let kolodaPost = KolodaPost(followerIndex: followerIndex)
            kolodaPosts.append(kolodaPost)
            kolodaPost.delegate = self
            kolodaPost.getPostsFromParse(secondDone())
        }
        print("reload pressed")
    }
    
    func secondDone(){
//        SwiftSpinner.hide()
        kolodaView.reloadData()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "bigImage") {
            var svc = segue.destinationViewController as! BigViewController
            svc.toPass = returnedImage
            
        }
    }
    func update(){
        SwiftSpinner.hide()
        if()
    }
    
    func getKolodaPostByFollowerIndex(followerIndex: Int) -> KolodaPost? {
        return kolodaPosts.filter({ return $0.followerIndex == followerIndex }).first
    }
}

// MARK: KolodaPostDelegate
extension BackgroundAnimationViewController: KolodaPostDelegate {
    func didGetImage(postImage: KolodaPostImage) -> Void {
        kolodaView.userInteractionEnabled = true
        self.kolodaPostsImages.append(postImage)
//        self.kolodaView.reloadData()
        self.kolodaView.resetCurrentCardIndex()
        if kolodaNumberOfCards(kolodaView) == 0{
                print("eyy")
                reloadView.hidden = false

        }
    }
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        kolodaView.userInteractionEnabled = false

        //show view if
        print("out of cards")
        reloadView.hidden = false
//        kolodaView.reloadData()
        
//        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        performSegueWithIdentifier("bigImage", sender: nil)
        
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

//MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(kolodaPostsImages.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        kolodaView.userInteractionEnabled = false

        print("view card")
        reloadView.hidden = true
        userInfoView.hidden = false
        let kPostImage: KolodaPostImage = kolodaPostsImages[Int(index)]
        currentArray = kPostImage.kolodaPost.followerIndex
        
        let currentPost: Post = kPostImage.post
        titleView.text = currentPost["title"] as! String
        let likesClass = currentPost["likes"] as! PFObject
        let likesNS = likesClass["numberOfLikes"]! as! NSNumber
        let likesInt = likesNS as Int
        likesView.text = "❤️" + String(likesInt)
        let userClass = currentPost["user"] as! PFObject
        print(userClass)
        let userNS = userClass["username"] as! NSString
        let userString = userNS as String
        usernameView.text = userString
        

        
        if Int(index) > kolodaPostsImages.count - 1 {
            return UIImageView(image: UIImage(named: "jkioklmkljl"))
        }
        print(currentIndexReturn)
        
               print("current array at source")
        print(currentArray)
        
        returnedImage = kolodaPostsImages[Int(index)].image
        print("image Index \(index)")
//        resetKolodaAlpha()
        var returnedView = UIImageView(image: returnedImage)
        returnedView.contentMode = .ScaleAspectFit
        return returnedView
    }
    func resetKolodaAlpha() {
        //this is fix for some unknown bug when you leave screen durring deck is presenting
        //and see invisible deck, but you able to swipe invisible card, then deck is appears
        kolodaView.alpha = 0.0
        kolodaView.alpha = 1.0
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        resetKolodaAlpha()
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",owner: self, options: nil)[0] as? OverlayView
    }
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
            // Change index to Int because literally no one uses UIn
        kolodaView.userInteractionEnabled = false

            switch direction.rawValue {
            case "Left" :
                print("left")
                currentIndexReturn += 1
                print(currentIndexReturn)
                let kPostImage: KolodaPostImage = kolodaPostsImages[Int(index)]
                currentArray = kPostImage.kolodaPost.followerIndex

                let currentPost: Post = kPostImage.post
                print("currentArray")
                print(currentArray)
                if currentArray == 1{
                    
                    currentPost["follower1HasSeen"] = true
                    var passedOnNS = currentPost["passedOn"] as! NSNumber
                    var passedOnInt = passedOnNS as Int
                    passedOnInt += 1
                    currentPost["passedOn"] = passedOnInt
                    if passedOnInt >= 3{
                        //deletpost
                    }
                }else if currentArray == 2{
                    
                    currentPost["follower2HasSeen"] = true
                    var passedOnNS = currentPost["passedOn"] as! NSNumber
                    var passedOnInt = passedOnNS as Int
                    passedOnInt += 1
                    currentPost["passedOn"] = passedOnInt
                    if passedOnInt >= 3{
                        //deletpost
                    }
                }else{
                    currentPost["follower3HasSeen"] = true
                    var passedOnNS = currentPost["passedOn"] as! NSNumber
                    var passedOnInt = passedOnNS as Int
                    passedOnInt += 1
                    currentPost["passedOn"] = passedOnInt
                    if passedOnInt >= 3{
                        //deletpost
                    }
                }
                currentPost.saveInBackground()

            break
    
            case "Right" :
                print("right")
                
                let kPostImage: KolodaPostImage = kolodaPostsImages[Int(index)]
                var currentPost: Post = kPostImage.post

                newPost = Post()
                if currentArray == 1{
                    //maybe have a pointer to original
                    currentPost["follower1HasSeen"] = true
                    let likesClass = currentPost["likes"] as! PFObject
                    let likesNS = likesClass["numberOfLikes"]! as! NSNumber
                    var likesInt = likesNS as Int
                    likesInt += 1
                    likesClass["numberOfLikes"]! = likesInt
                    newPost["likes"] = currentPost["likes"]
                    var passedOnNS = currentPost["passedOn"] as! NSNumber
                    var passedOnInt = passedOnNS as Int
                    passedOnInt += 1
                    currentPost["passedOn"] = passedOnInt
                    newPost["title"] = currentPost["title"]
                    newPost["user"] = currentPost["user"]
    
                    newPost["user"] = currentPost["user"]
    
                    newPost.image.value = kPostImage.image
                    if passedOnInt >= 3{
                        //deletpost
                    }
 
    
    
                }else if currentArray == 2{
                    currentPost["follower2HasSeen"] = true
                    let likesClass = currentPost["likes"] as! PFObject
                    let likesNS = likesClass["numberOfLikes"]! as! NSNumber
                    var likesInt = likesNS as Int
                    likesInt += 1
                    likesClass["numberOfLikes"]! = likesInt
                    newPost["likes"] = currentPost["likes"]
                    var passedOnNS = currentPost["passedOn"] as! NSNumber
                    var passedOnInt = passedOnNS as Int
                    passedOnInt += 1
                    currentPost["passedOn"] = passedOnInt
                    newPost["title"] = currentPost["title"]
                    newPost["user"] = currentPost["user"]
                    
                    newPost["user"] = currentPost["user"]
                    newPost.image.value = kPostImage.image

                    
                    if passedOnInt >= 3{
                        //deletpost
                    }

                }else{
                    currentPost["follower3HasSeen"] = true
                    let likesClass = currentPost["likes"] as! PFObject
                    let likesNS = likesClass["numberOfLikes"]! as! NSNumber
                    var likesInt = likesNS as Int
                    likesInt += 1
                    likesClass["numberOfLikes"]! = likesInt
                    newPost["likes"] = currentPost["likes"]
                    var passedOnNS = currentPost["passedOn"] as! NSNumber
                    var passedOnInt = passedOnNS as Int
                    passedOnInt += 1
                    currentPost["passedOn"] = passedOnInt
                    newPost["title"] = currentPost["title"]
                    newPost["user"] = currentPost["user"]
                    
                    newPost["user"] = currentPost["user"]
                    newPost.image.value = kPostImage.image

                    
                    if passedOnInt >= 3{
                        //deletpost
                    }
                }
                currentPost.saveInBackground()

                newPost["follower1HasSeen"] = false
                newPost["follower2HasSeen"] = false
                newPost["follower3HasSeen"] = false
                newPost["sentFrom"] = PFUser.currentUser()
                newPost["passedOn"] = 0
                found = ParseHelper.findFollowing(arrayDone)
    
    
            break
    
            default :
                print("Not a valid direction.")
                break
            }
        }
        func arrayDone(){
    
            found = confirmPostViewController.foundFollowers
    
            let numberOfFollowers = found.count
    
            let currentDate = NSDate()
    
            let currentDateComponents = NSDateComponents()
    
            currentDateComponents.timeZone = NSTimeZone(abbreviation: "GMT")
    
            var hoursToAdd: Int = 0
            var minutesToAdd: Int = 0
            if numberOfFollowers > 2{
                let follower1Int = Int(arc4random_uniform(UInt32(numberOfFollowers)))
                var follower2Int = Int(arc4random_uniform(UInt32(numberOfFollowers)))
                if follower2Int == follower1Int{
                    while follower2Int == follower1Int{
                        follower2Int = Int(arc4random_uniform(UInt32(numberOfFollowers)))
                    }
                }
                var follower3Int = Int(arc4random_uniform(UInt32(numberOfFollowers)))
                if follower3Int == follower2Int || follower3Int == follower1Int{
                    while follower3Int == follower2Int || follower3Int == follower1Int{
                        follower3Int = Int(arc4random_uniform(UInt32(numberOfFollowers)))
                    }
                }
                newPost["follower1"] = found[follower1Int]
                newPost["follower2"] = found[follower2Int]
                newPost["follower3"] = found[follower3Int]

                if numberOfFollowers < 11{
                    
                    minutesToAdd = 0
                    hoursToAdd = 24
                    
                }else if numberOfFollowers < 26{
                    
                    minutesToAdd = 0
                    hoursToAdd = 12
                    
                }else if numberOfFollowers < 51{
                    
                    minutesToAdd = 0
                    hoursToAdd = 6
                    
                }else if numberOfFollowers < 101{
                    
                    minutesToAdd = 0
                    hoursToAdd = 2
                    
                }else if numberOfFollowers < 251{
                    
                    hoursToAdd = 1
                    
                }else if numberOfFollowers < 501{
                    
                    minutesToAdd = 30
                    
                }else{
                    
                    minutesToAdd = 15
                    
                }
                

            }else{
                hoursToAdd = 2147483640
                if numberOfFollowers == 0{
                    newPost["follower1"] = nil
                    newPost["follower2"] = nil
                    newPost["follower3"] = nil
                }else if numberOfFollowers == 1{
                    newPost["follower1"] = found[0]
                    newPost["follower2"] = nil
                    newPost["follower3"] = nil
                }else{
                    newPost["follower1"] = found[0]
                    newPost["follower2"] = found[1]
                    newPost["follower3"] = nil
                }
               
            }
    
            
            currentDateComponents.hour = hoursToAdd
            currentDateComponents.minute = minutesToAdd
            
            let calculatedDate = NSCalendar.currentCalendar().dateByAddingComponents(currentDateComponents, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
            
            newPost["follower1Expire"] = calculatedDate
            newPost["follower2Expire"] = calculatedDate
            newPost["follower3Expire"] = calculatedDate
            print("uploading")
            newPost.uploadPost()
        
        func finishedGettingFollowers (followers: [PFUser]) {
            BackgroundAnimationViewController.foundFollowers = followers
        }
                
    
    }
}
