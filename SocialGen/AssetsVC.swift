//
//  AssetsVC.swift
//  SocialGen
//
//  Created by Nicole Yarroch on 6/29/15.
//  Copyright (c) 2015 Nicole Yarroch. All rights reserved.
//

import Foundation
import Socket_IO_Client_Swift

class AssetsVC : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var assetsTable: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    let socket = SocketIOClient(socketURL: "localhost:3000")
    let cellIdentfier = "cell"
    lazy var values = [AsssetsObject]()
    
    @IBOutlet weak var tableView: UITableView!
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
        self.assetsTable.delegate = self
        self.assetsTable.dataSource = self
        configureTableView()
        
    }
    
    // MARK: - Socket.io
    func addHandlers() {
        
        // This handler is called on any event KEEP
//        self.socket.onAny {println("Got event: \($0.event), with items: \($0.items)")}
        
        self.socket.on("assetImage") {[weak self] data, ack in
            
            // Create a new Asset object
            var asset : AsssetsObject = AsssetsObject()
            
            // Save image
            if let userImage : String = data?[0] as? String {
                asset.image = userImage
            }
            
            // Save title
            if let userTitle : String = data?[1] as? String {
                asset.title = userTitle
            }
            
            // Begin updates to table
            self?.assetsTable.beginUpdates()
            
            // Save Asset object to array
            self?.values.insert(asset, atIndex: 0)
            
            // Add new content to beginning of table
            var indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self?.assetsTable.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
            
            self?.assetsTable.endUpdates()
        }
    }

    // MARK: - Table View
    func configureTableView() {
        self.assetsTable.rowHeight = UITableViewAutomaticDimension
        self.assetsTable.estimatedRowHeight = 160.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 182
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return basicCellAtIndexPath(indexPath)
    }
    
    func basicCellAtIndexPath(indexPath:NSIndexPath) -> AssetsCell {
        let cell = self.assetsTable.dequeueReusableCellWithIdentifier(self.cellIdentfier) as! AssetsCell
        
        // Image
        if let imageBase64 : String = self.values[indexPath.row].image as String? {
            
            // Decode the Base64 image
            var url : NSURL = NSURL(string: imageBase64)!
            var decodedData : NSData = NSData(contentsOfURL: url)!
            var decodedImage : UIImage = UIImage(data: decodedData)!
            
            // Set the cell image
            // Set "Clip to subview" in storyboard on the UIImageView to prevent the image
            // from begin too big for cell
            cell.assetImage.contentMode = UIViewContentMode.ScaleAspectFill
            cell.assetImage.image = decodedImage
        }
        
        // Title
        let title : String = "\(self.values[indexPath.row].title)"
        cell.assetTitle.text = title
        
        return cell
    }

}