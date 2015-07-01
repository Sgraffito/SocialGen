//
//  MapHotSpotsVC.swift
//  SocialGen
//
//  Created by Nicole Yarroch on 6/24/15.
//  Copyright (c) 2015 Nicole Yarroch. All rights reserved.
//

import Foundation
import MapKit
import Socket_IO_Client_Swift

class MapHotSpotsVC : UIViewController, MKMapViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    let socket = SocketIOClient(socketURL: "localhost:3000")
    lazy var values = [TweetObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Menu hamburger icon
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Socket.io
        self.addHandlers()
        self.socket.connect()

        
        // Map zone
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(1.0 , 1.0)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 42.3314, longitude: -83.0458)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
        
        // Show artwork on map
        let artwork = Artwork(title: "Test", subtitle: "More test", image: "1", locationName: "Somewhere" , coordinate: CLLocationCoordinate2D(latitude: 42.4414, longitude: -83.0458))
        mapView.addAnnotation(artwork)
        
        // Timer
        var timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    func update() {
        
        if self.values.count > 0 {
            
            println("Adding annotation")
            
            var lat = self.randRange(25, upper: 71.23)
            var long = self.randRange(-100, upper: -150)
            
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
            
            var item = self.values[0] as TweetObject
            
            if item.asset == "nil" {
                // Do nothing for now
//                var anotation = MKPointAnnotation()
//                anotation.coordinate = location
//                anotation.title = item.title
//                anotation.subtitle = item.tweet
//                self.mapView.addAnnotation(anotation)
//                self.mapView.selectAnnotation(anotation, animated: true)
                let artwork = Artwork(title: item.title, subtitle: item.tweet, image: "blueImage", locationName: "Somewhere" , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                mapView.addAnnotation(artwork)
                mapView.selectAnnotation(artwork, animated: true)
            }
            else {
                let artwork = Artwork(title: item.title, subtitle: item.tweet, image: item.asset, locationName: "Somewhere" , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                mapView.addAnnotation(artwork)
                mapView.selectAnnotation(artwork, animated: true)
                
//                mapView.addAnnotation(artwork)
//                var anotation = MKPointAnnotation()
//                anotation.coordinate = location
//                anotation.title = item.title
//                anotation.subtitle = item.tweet
//                self.mapView.addAnnotation(anotation)
//                self.mapView.selectAnnotation(anotation, animated: true)
            }
            
            // remove item from array
            self.values.removeAtIndex(0)
        }
    }
    
    func randRange (lower : Double , upper : Double) -> Double {
        let difference = upper - lower
        return Double(Float(rand())/Float(RAND_MAX) * Float(difference + 1)) + lower
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
                    
                    // Save the object
                    self?.values.append(tweet)
            }
        }
    }
    
    // MARK: - Map View
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            
            let view = annotation as! Artwork
            
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.image = UIImage(named:"redDot")
            anView.canShowCallout = true
            

            let viewLeftAccessory : UIView = UIView(frame: CGRectMake(0, 0, 89, 59))
            let temp : UIImageView = UIImageView(frame: CGRectMake(5, 5, 89 - 10, 59 - 10))
            temp.contentMode = UIViewContentMode.ScaleAspectFit
            viewLeftAccessory.addSubview(temp)
            anView.leftCalloutAccessoryView = viewLeftAccessory
            
            
//            UIView *viewLeftAccessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pinView.frame.size.height, pinView.frame.size.height)]
//            
//            UIImageView *temp=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, pinView.frame.size.height- 10, pinView.frame.size.height -10)];
//            temp.image = image;
//            temp.contentMode = UIViewContentModeScaleAspectFit;
//            
//            [viewLeftAccessory addView:temp];
//            
//            pinView.leftCalloutAccessoryView=viewLeftAccessory;
            
            
            
            anView.leftCalloutAccessoryView = UIImageView(frame: CGRectMake(0, 0, 89, 59))
            anView.leftCalloutAccessoryView.contentMode = UIViewContentMode.ScaleAspectFill
            anView.leftCalloutAccessoryView.clipsToBounds = true
        
//            if view.image == "1" {
//                var assetImage = UIImageView(image: UIImage(named: view.image))
//                anView.leftCalloutAccessoryView = assetImage
//            }
//            else if view.image == "blueImage" {
//                var assetImage = UIImageView(image: UIImage(named: view.image))
//                anView.leftCalloutAccessoryView = assetImage
//            }
//            else {
//                
//                // Image
//                if let imageBase64 : String = view.image as String? {
//                    
//                    // Decode the Base64 image
//                    var url : NSURL = NSURL(string: imageBase64)!
//                    var decodedData : NSData = NSData(contentsOfURL: url)!
//                    var decodedImage : UIImage = UIImage(data: decodedData)!
//                    
//                    // Set the cell image
//                    // Set "Clip to subview" in storyboard on the UIImageView to prevent the image
//                    // from begin too big for cell
//                    anView.leftCalloutAccessoryView.contentMode = UIViewContentMode.ScaleAspectFill
//                    anView.leftCalloutAccessoryView = UIImageView(image: decodedImage)
//                }
//                
//            }
           
           
            // Add image to left callout
//            var mugIconView = UIImageView(image: UIImage(named: "1"))
//            anView!.leftCalloutAccessoryView = mugIconView
            
            // Add detail button to right callout
            var calloutButton = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
            anView!.rightCalloutAccessoryView = calloutButton

        }
        else {
            //we are re-using a view, update its annotation reference...
            anView.annotation = annotation
        }
        
        
        return anView
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        
        // Annotations are not in order - doesn't work
//        println("Added annotation")
//        let obj : MKAnnotation = mapView.annotations.last as! MKAnnotation
//        mapView.selectAnnotation(obj, animated: true)
    }
}


