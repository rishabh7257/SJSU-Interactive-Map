//
//  ViewController.swift
//  Lab3
//
//  Created by Rishabh Sanghvi on 11/3/15.
//  Copyright © 2015 Rishabh Sanghvi. All rights reserved.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController,UIScrollViewDelegate  {
    var transform : CGAffineTransform!
    @IBOutlet weak var myLocationButton: UIButton!
    
    @IBOutlet weak var SearchBtn: UIButton!
    @IBOutlet var scView: UIScrollView!
    @IBOutlet var mapsView: Widget!
    var widget: Widget! = Widget()
    var searchButton : UIButton?
    var currentLocation : UIButton?
    let playImage = UIImage(named: "play")
    let currentLocationImage = UIImage(named: "myLocation")
    let defaults = NSUserDefaults.standardUserDefaults()
    

    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        i = 0
        self.scView.minimumZoomScale = 1
        self.scView.maximumZoomScale = 6
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOFReceivedNotication:", name: "NotificationIdentifier", object: nil)
        
       
        
        self.searchButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width - 90, y: self.view.frame.height / 1.30 + 40), size: CGSize(width: 50, height: 50)))
        self.searchButton!.setBackgroundImage(playImage, forState: UIControlState.Normal)
        self.view.addSubview(searchButton!)
        self.view.bringSubviewToFront(searchButton!)
        self.searchButton!.addTarget(self, action: "searchButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)

         self.currentLocation = UIButton(frame: CGRect(origin: CGPoint(x: 20, y: self.view.frame.height / 1.30 + 40), size: CGSize(width: 50, height: 50)))
        self.currentLocation!.setBackgroundImage(currentLocationImage, forState: UIControlState.Normal)
        self.view.addSubview(currentLocation!)
        self.view.bringSubviewToFront(currentLocation!)
        self.currentLocation!.addTarget(self, action: "myLocationClicked:", forControlEvents: UIControlEvents.TouchUpInside)
       
        
        self.navigationController?.navigationBarHidden = true
        let twoFingerPinch = UIPinchGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        self.view.addGestureRecognizer(twoFingerPinch)
        
        if let zoomScale = defaults.stringForKey("zoom level") {
            print("Application logged in zoom scale \(String(zoomScale))")
            if let zoolScaleFloat =  NSNumberFormatter().numberFromString(zoomScale) {
                let zoomScaleCGFloat : CGFloat = CGFloat(zoolScaleFloat)
                scView.setZoomScale(zoomScaleCGFloat, animated: true)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("Current Zoom Level is  \(scale.description)")
        defaults.setFloat(Float(scale), forKey: "zoom level")
        defaults.synchronize()
    }
    
    
    func methodOFReceivedNotication(notification: NSNotification) {
        guard let dataObj: DataObj? = notification.object as? DataObj else {
            return
        }
        print("In Notification")
        print(dataObj!.getBuildingName())
        self.view.bringSubviewToFront(SearchBtn)
        let buildingCordinates = getBuildingLatLong((dataObj?.getBuildingName())!)
        
        let point : CGPoint = CGPointMake(CGFloat(buildingCordinates["x"]!), CGFloat(buildingCordinates["y"]!));
        
        let xStart : Int = Int(point.x);
        let yStart : Int = Int(point.y);
        
        let innerCircleRect : CGRect = CGRectMake(CGFloat(xStart), CGFloat(yStart), 10, 10)
        
        let innerCircleView : UIView = UIView(frame: innerCircleRect)
        innerCircleView.tag = 999
        
        innerCircleView.backgroundColor = UIColor.redColor();
        innerCircleView.layer.cornerRadius = 10.0;
        self.mapsView.addSubview(innerCircleView);
        let scrollViewSize: CGSize = self.view.bounds.size
        
        let w: CGFloat = scrollViewSize.width / 2;
        let h: CGFloat = scrollViewSize.height / 2
        let x = CGFloat(buildingCordinates["x"]!) - (w/2.0)
        let y = CGFloat(buildingCordinates["y"]!) //- (h/2.0)
        
        let rectTozoom=CGRectMake(x, y, w, h)
        self.scView.zoomToRect(rectTozoom, animated: true)
        self.scView.scrollRectToVisible(rectTozoom, animated: true)
    }
    
    func respondToSwipeGesture(gesture: UIPinchGestureRecognizer){
        if(gesture.scale < 2 && gesture.scale > 0.5){
        transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
        self.view.transform = transform;
        transform = CGAffineTransformMakeScale(2, 2);
        
        }
    }
    
    override func viewDidAppear(animated: Bool) {
            let twoFingerPinch = UIPinchGestureRecognizer(target: self, action: "respondToSwipeGesture:")
            self.view.addGestureRecognizer(twoFingerPinch)
    }
    
    func searchButtonClicked(sender: UIButton){
        if let viewWithTag = self.view.viewWithTag(999) {
            viewWithTag.removeFromSuperview()
        }
        self.performSegueWithIdentifier("segueExercise", sender: self)
    }
    
    func myLocationClicked(sender: UIButton) {
        self.performSegueWithIdentifier("myLocation", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueExercise") {
        }
        if(segue.identifier == "myLocation"){
            self.navigationController?.navigationBarHidden = false
            
            let detailVC = segue.destinationViewController as! MyLocation
            if let loc = segueMyLocation {
                detailVC.longitude = loc.longitude
                detailVC.lattitude =  loc.latitude
            }
        }
    }
    
    func getBuildingLatLong(buildingName: String) -> [String : Float]{
        
        var x: Float!
        var y: Float!
        
        switch(buildingName) {
            case "King Library":
                x = 110
                y = 140
                break
            case "Engineering Building":
                x = 385
                y = 150
                break
            case "Yoshihiro Uchida Hall":
                x = 100
                y = 240
                break
            case "BBC":
                x = 585
                y = 230
                break
            case "Student Union":
                x = 393
                y = 195
                break
            case "South​P​arking​G​arage":
                x = 248
                y = 310
                break
            default:
                break
        }
        
        let buildingCordinates: [String : Float] = ["x" : x, "y" : y]
        return buildingCordinates
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.mapsView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}