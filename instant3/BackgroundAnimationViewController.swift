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
    
    @IBOutlet weak var spinnerContainerView: UIView!
    
    var realIndex: Int!
    
    var kolodaPosts = [KolodaPost]()
    var kolodaPostsImages = [KolodaPostImage]()
    
    var found = [PFUser]()
    
    var currentArray = 4
    var returnedImage: UIImage?
    
    var photoUploadTask: UIBackgroundTaskIdentifier?

    var newPost: Post!
    static var foundFollowers = [PFUser]()

    var returnImage: UIImage!
    var currentIndexReturn: Int = 0
    //MARK: Lifecycle
    var indexOfLoop: Int = 0
    var indexOfUpdate: Int = 0
    
    
    @IBAction func flag(_ sender: AnyObject) {
        let kPostImage: KolodaPostImage = kolodaPostsImages[realIndex]
        let currentPost: Post = kPostImage.post
        showFlagActionSheetForPost(currentPost)
    }
    

    override func viewDidLoad() {
        
        kolodaView.userInteractionEnabled = false
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        for followerIndex in 1..<4 {
            let kolodaPost = KolodaPost(followerIndex: followerIndex)
            kolodaPosts.append(kolodaPost)
            kolodaPost.delegate = self
            kolodaPost.getPostsFromParse(update)
        }
        let currentUser = PFUser.currentUser()!
        if currentUser["profilePicture"] == nil {
            let currentUser = PFUser.currentUser()
            let imageThing = UIImagePNGRepresentation(UIImage(named: "Circled User Male-100")!)
            let file = PFFile(data: imageThing!)
            currentUser!["profilePicture"] = file
        currentUser!.saveInBackgroundWithBlock(nil)
            self.photoUploadTask = UIApplication.shared.beginBackgroundTask (expirationHandler: { () -> Void in
                UIApplication.shared.endBackgroundTask(self.photoUploadTask!)
            })
        }

        
    }
    func showFlagActionSheetForPost(_ post: Post) {
        let alertController = UIAlertController(title: nil, message: "Do you want to flag this post?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Flag", style: .Destructive) { (action) in
            post.flagPost(PFUser.currentUser()!)
        }
        
        alertController.addAction(destroyAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    

    @IBAction func unwindToBackgroundAnimationController(_ segue: UIStoryboardSegue) {
        
    }
    
   
    @IBAction func reloadPressed(_ sender: AnyObject) {
        SwiftSpinner.show("Finding more posts")
        kolodaPosts.removeAll()
        kolodaPostsImages.removeAll()
       for followerIndex in 1..<4 {
            let kolodaPost = KolodaPost(followerIndex: followerIndex)
            kolodaPosts.append(kolodaPost)
            kolodaPost.delegate = self
            kolodaPost.getPostsFromParse(secondDone)
      }
     
        
    }
    
    func secondDone(){
        indexOfLoop += 1
        if indexOfLoop > 2 {
            if kolodaPosts.filter({ !$0.posts.isEmpty }).isEmpty {
                print("empty 2")
                SwiftSpinner.hide()
                reloadView.isHidden = false
            }else{
                print("not empty")
                reloadView.isHidden = true

            }
            SwiftSpinner.hide()
//            kolodaView.reloadData()


        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "bigImage") {
            let svc = segue.destination as! BigViewController
            svc.toPass = returnedImage
            
        }
    }
    func update(){
        print("update")
        print(kolodaPosts)
        indexOfUpdate += 1
        if indexOfUpdate > 2{
            if kolodaPosts.filter({ !$0.posts.isEmpty }).isEmpty {
                print("empty")
                reloadView.isHidden = false
            }
        }
    }
    
    func getKolodaPostByFollowerIndex(_ followerIndex: Int) -> KolodaPost? {
        return kolodaPosts.filter({ return $0.followerIndex == followerIndex }).first
    }
}

// MARK: KolodaPostDelegate
extension BackgroundAnimationViewController: KolodaPostDelegate {
    func didGetImage(_ postImage: KolodaPostImage) -> Void {
        print("get image")
        kolodaView.userInteractionEnabled = true
        self.kolodaPostsImages.append(postImage)
        self.kolodaView.reloadData()
        self.kolodaView.resetCurrentCardIndex()
        if kolodaNumberOfCards(kolodaView) == 0{
                reloadView.isHidden = false
        }
    }
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaPostsImages.removeAll()
        kolodaView.userInteractionEnabled = false
        print("outta cards")
        userInfoView.isHidden = true
        //show view if
        reloadView.isHidden = false
        kolodaPosts.removeAll()
        
        
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        performSegue(withIdentifier: "bigImage", sender: nil)
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
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
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> UInt {
        return UInt(kolodaPostsImages.count)
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
    
        SwiftSpinner.hide()
        realIndex = Int(index)
        reloadView.isHidden = true
        resetKolodaAlpha()

        let kPostImage: KolodaPostImage = kolodaPostsImages[Int(index)]
        var kPostSource: KolodaPostImage = kolodaPostsImages[Int(index)]
        if index != 0{
            kPostSource = kolodaPostsImages[Int(index-1)]
        }else if Int(index) == kolodaPostsImages.count-1{
            if kolodaPostsImages.count > 1{
                print("here")
                kPostSource = kolodaPostsImages[Int(index+1)]
            }
    
        }
        

            
        currentArray = kPostSource.kolodaPost.followerIndex
        
        let currentPost: Post = kPostImage.post
        titleView.text = currentPost["title"] as! String
        let currentUser = currentPost["user"]
        currentUser.refreshInBackgroundWithBlock { (object, error) -> Void in
            // 2
            currentUser.fetchIfNeededInBackgroundWithBlock { (obj: PFObject?, error: NSError?) -> Void in
                if obj != nil {
                    var fetchedUser = obj as! PFUser
                    
                    if var oldImageFile = fetchedUser["profilePicture"]
                    {
                        oldImageFile.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                            self.profilePickView.image = UIImage(data: data!)
                        }
                    }
                }
            }
        }
        let likesClass = currentPost["likes"] as! PFObject
        let likesNS = likesClass["numberOfLikes"]! as! NSNumber
        let likesInt = likesNS as Int
        likesView.text = "❤️" + String(likesInt)
        
        let userClass = currentPost["user"] as! PFObject
        let userNS = userClass["username"] as! NSString
        let userString = userNS as String
        usernameView.text = userString
        
        if Int(index) > kolodaPostsImages.count - 1 {
            return UIImageView(image: UIImage(named: "jkioklmkljl"))
        }
        
        returnedImage = kolodaPostsImages[Int(index)].image
        let returnedView = UIImageView(image: returnedImage)
        returnedView.contentMode = .scaleAspectFit

        return returnedView
    }
    func resetKolodaAlpha() {
        //this is fix for some unknown bug when you leave screen durring deck is presenting
        //and see invisible deck, but you able to swipe invisible card, then deck is appears
        kolodaView.alpha = 0.0
        kolodaView.alpha = 1.0
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
//        resetKolodaAlpha()
        print("overlay")
        userInfoView.isHidden = false

        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",owner: self, options: nil)[0] as? OverlayView
    }
    func koloda(_ koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
            // Change index to Int because literally no one uses UIn
        kolodaView.userInteractionEnabled = true

            switch direction.rawValue {
            case "Left" :
                currentIndexReturn += 1
                
                let kPostImage: KolodaPostImage = kolodaPostsImages[Int(index)]

                let currentPost: Post = kPostImage.post
                if currentArray == 1{
                    
                    currentPost["follower1HasSeen"] = true
                    let passedOnNS = currentPost["passedOn"] as! NSNumber
                    var passedOnInt = passedOnNS as Int
                    passedOnInt += 1
                    currentPost["passedOn"] = passedOnInt
                    
                    if passedOnInt >= 3{
                        //deletpost
                    }
                }else if currentArray == 2{
                    
                    currentPost["follower2HasSeen"] = true
                    let passedOnNS = currentPost["passedOn"] as! NSNumber
                    var passedOnInt = passedOnNS as Int
                    passedOnInt += 1
                    currentPost["passedOn"] = passedOnInt
                    if passedOnInt >= 3{
                        //deletpost
                    }
                }else{
                    currentPost["follower3HasSeen"] = true
                    let passedOnNS = currentPost["passedOn"] as! NSNumber
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
                let kPostImage: KolodaPostImage = kolodaPostsImages[Int(index)]
                let currentPost: Post = kPostImage.post

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
                    let passedOnNS = currentPost["passedOn"] as! NSNumber
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
                    
                    let passedOnNS = currentPost["passedOn"] as! NSNumber
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
    
            let currentDate = Date()
    
            var currentDateComponents = DateComponents()
    
            (currentDateComponents as NSDateComponents).timeZone = TimeZone(abbreviation: "GMT")
    
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
            
            let calculatedDate = (Calendar.current as NSCalendar).date(byAdding: currentDateComponents, to: currentDate, options: NSCalendar.Options.init(rawValue: 0))
            
            newPost["follower1Expire"] = calculatedDate
            newPost["follower2Expire"] = calculatedDate
            newPost["follower3Expire"] = calculatedDate
            print("uploading")
            newPost.uploadPost()
        
        func finishedGettingFollowers (_ followers: [PFUser]) {
            BackgroundAnimationViewController.foundFollowers = followers
        }
                
    
    }
}
