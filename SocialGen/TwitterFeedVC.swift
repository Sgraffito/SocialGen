//
//  TwitterFeedVC.swift
//  SocialGen
//
//  Created by Nicole Yarroch on 6/24/15.
//  Copyright (c) 2015 Nicole Yarroch. All rights reserved.
//

import Foundation
import Socket_IO_Client_Swift

class TwitterFeedVC : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var feedTable: UITableView!
    let socket = SocketIOClient(socketURL: "localhost:3000")
    lazy var values = [TweetObject]()
    let cellIdentfier = "cell"
    let cellImageIdentfier = "imageCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Menu button in the nav bar
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Socket.io
        self.addHandlers()
        self.socket.connect()
        
        // Table
        configureTableView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        println("Exiting view")
       socket.emit("disconnect", "leaving")
    }
    override func viewDidDisappear(animated: Bool) {
//        super.viewDidDisappear(animated: Bool)
//        socket.emit("disconnect", "leaving")
    }
    
    // MARK: - Socket.io
    func addHandlers() {
        
        // This handler is called on any event KEEP FOR TESTING
//        self.socket.onAny {println("Got event: \($0.event), with items: \($0.items)")}
        
        self.socket.on("playerMove") {[weak self] data, ack in

            if let title = data?[0] as? String, at = data?[1] as? String,
                tweet = data?[2] as? String, date = data?[3] as? String,
                userIcon = data?[4] as? String, userAsset = data?[5] as? String {
                
                    var tweet : TweetObject = TweetObject()
                    if let tweetTitle : String = data?[0] as? String {
                        tweet.title = tweetTitle
                    }
                    if let tweetAt : String = data?[1] as? String {
                        tweet.at = tweetAt
                    }
                    if let tweetTweet : String = data?[2] as? String {
                        tweet.tweet = tweetTweet
                    }
                    if let tweetDate : String = data?[3] as? String {
                        tweet.date = tweetDate
                    }
                    if let tweetImageIcon : String = data?[4] as? String {
                        tweet.icon = tweetImageIcon
                    }
                    
                    if let tweetImageAsset : String = data?[5] as? String {
                        tweet.asset = tweetImageAsset
                    }
                    
                    self?.feedTable.beginUpdates()

                    self?.values.insert(tweet, atIndex: 0)
                    
                    var indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    self?.feedTable.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
                    
                    self?.feedTable.endUpdates()
            }
        }
    }


    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func configureTableView() {
        self.feedTable.rowHeight = UITableViewAutomaticDimension
        self.feedTable.estimatedRowHeight = 160.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if hasImageAtIndexPath(indexPath) {
            return imageCellAtIndexPath(indexPath)
            
        } else {
            return basicCellAtIndexPath(indexPath)
        }
    }
    
    func imageCellAtIndexPath(indexPath:NSIndexPath) -> TwitterFeedImageCell {
        let cell = self.feedTable.dequeueReusableCellWithIdentifier(self.cellImageIdentfier) as! TwitterFeedImageCell
        setTitleForCell(cell, indexPath: indexPath)
        setSubtitleForCell(cell, indexPath: indexPath)
        setDateTimeForCell(cell, indexPath: indexPath)
        setImageIconForCell(cell, indexPath: indexPath)
        setImageAssetForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func hasImageAtIndexPath(indexPath:NSIndexPath) -> Bool {
        
        let item : String = "\(self.values[indexPath.row].asset)"

        if item == "nil" {
            return false
        }
        
        return true
//        let item = items[indexPath.row]
//        let mediaThumbnailArray = item.mediaThumbnails as! [RSSMediaThumbnail]
//        
//        for mediaThumbnail in mediaThumbnailArray {
//            if mediaThumbnail.url != nil {
//                return true
//            }
//        }
    }
    
    func basicCellAtIndexPath(indexPath:NSIndexPath) -> TwitterFeedCell {
        let cell = self.feedTable.dequeueReusableCellWithIdentifier(self.cellIdentfier) as! TwitterFeedCell
        setTitleForCell(cell, indexPath: indexPath)
        setSubtitleForCell(cell, indexPath: indexPath)
        setDateTimeForCell(cell, indexPath: indexPath)
        setImageIconForCell(cell, indexPath: indexPath)
        return cell
    }
    
    
    func setTitleForCell(cell:TwitterFeedCell, indexPath:NSIndexPath) {
                
        // Title and at
        let item : String = "\(self.values[indexPath.row].title)  "
        let at : String = "\(self.values[indexPath.row].at)"
        
        // Attributed string
        let para = NSMutableAttributedString()
        
        var titleAttributes = [NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(18.0, weight: 2.0)]
        var completeTitle = NSMutableAttributedString(string: item, attributes: titleAttributes)
        var atAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(14.0), NSForegroundColorAttributeName : UIColor.grayColor()]
        var gString = NSMutableAttributedString(string: at, attributes: atAttributes)
        
        // Append at to the title
        para.appendAttributedString(completeTitle)
        para.appendAttributedString(gString)
        
        cell.titleLabel.attributedText = para
    }
    
    func setSubtitleForCell(cell:TwitterFeedCell, indexPath:NSIndexPath) {
        let item : String = "\(self.values[indexPath.row].tweet)"
        var subtitle: NSString? = item ?? "[No Subtitle]"
        
        if let subtitle = subtitle {
            
            // Some subtitles are really long, so only display the first 200 characters
            if subtitle.length > 200 {
                cell.subtitleLabel.text = "\(subtitle.substringToIndex(200))..."
                
            } else {
                cell.subtitleLabel.text = subtitle as String
            }
            
        } else {
            cell.subtitleLabel.text = ""
        }
    }
    
    func setDateTimeForCell(cell:TwitterFeedCell, indexPath:NSIndexPath) {
        
        let item : String = "\(self.values[indexPath.row].date)"
        var dateTime : NSString? = item ?? "[No Date/Time]"
        
        if let dateTime = dateTime {
            cell.date.text = dateTime as String
        }
        else {
            cell.date.text = ""
        }
    }
    
    func setImageIconForCell(cell:TwitterFeedCell, indexPath:NSIndexPath) {
        
        // Image
        if let imageBase64 : String = self.values[indexPath.row].icon as String? {
            
            // Decode the Base64 image
            var url : NSURL = NSURL(string: imageBase64)!
            var decodedData : NSData = NSData(contentsOfURL: url)!
            var decodedImage : UIImage = UIImage(data: decodedData)!
            
            // Set the cell image
            // Set "Clip to subview" in storyboard on the UIImageView to prevent the image
            // from begin too big for cell
            cell.userIcon.contentMode = UIViewContentMode.ScaleAspectFill
            cell.userIcon.image = decodedImage
        }
    }
    
    func setImageAssetForCell(cell:TwitterFeedImageCell, indexPath:NSIndexPath) {
        
        // Image
        if let imageBase64 : String = self.values[indexPath.row].asset as String? {
            
            // Decode the Base64 image
            var url : NSURL = NSURL(string: imageBase64)!
            var decodedData : NSData = NSData(contentsOfURL: url)!
            var decodedImage : UIImage = UIImage(data: decodedData)!
            
            // Set the cell image
            // Set "Clip to subview" in storyboard on the UIImageView to prevent the image
            // from begin too big for cell
            cell.imageAsset.contentMode = UIViewContentMode.ScaleAspectFill
            cell.imageAsset.image = decodedImage
        }
    }

}