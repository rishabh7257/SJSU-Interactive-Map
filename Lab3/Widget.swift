//
//  Widget.swift
//  Lab3
//
//  Created by Rishabh Sanghvi on 11/3/15.
//  Copyright (c) 2015 Rishabh Sanghvi. All rights reserved.
//

import UIKit
import GoogleMaps
var segueMyLocation : CLLocationCoordinate2D!


@IBDesignable class Widget: UIView, CLLocationManagerDelegate {

    var popUpImage: UIImageView!
    var buildingName: UILabel!
    var address: UILabel!
    var distance: UILabel!
    var time: UILabel!
    var buildingNameText: String = ""
    var buildingNameSmall: String = ""
    
    
    @IBOutlet weak var mapView: UIImageView! 
       
    
    var myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    let googleMaps: GoogleMap = GoogleMap()
    var buildinhCordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    func getCurrentLocation(status: Bool) {
        // For use in foreground
        if(status) {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        } else {
            self.locationManager.stopUpdatingLocation()
        }
    }
    var rotatedImage : UIImageView!
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = manager.location {
            self.myLocation = loc.coordinate
            if(self.myLocation.longitude != 0.0) {
                segueMyLocation = self.myLocation
                self.getBuildingCordinatesForAddress(self.buildingNameText, origin: self.myLocation)
                getCurrentLocation(false)
                self.locationManager.stopUpdatingLocation()
            }
        }
        print("locations = \(myLocation.latitude) \(myLocation.longitude)")
        //self.setBuildingAttributes(self.buildingNameText)
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location \(error.localizedDescription)")
    }
    
    
    var view: UIView!
    var offset: CGPoint!
    var xAry: [Float]! = []
    var yAry: [Float]! = []
    
    @IBOutlet var overlay: UIView!
    
    var touch: UITouch!
    var nibName: String = "Widget"
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBInspectable var image: UIImage? {
        get {
            return imageView.image
        }
        set(image) {
            imageView.image = image
        }
    }
    
    @IBInspectable var imagePopUp: UIImage? {
        get {
            return popUpImage.image
        }
        set(image) {
            popUpImage.image = image
        }
    }
    
    // init
     override init(frame: CGRect) {
        // properties
        offset = CGPoint(x: 0, y: 0)
        super.init(frame: frame)

        // Set anything that uses the view or visible bounds
        setup()
        //getCurrentLocation(true)
    }
    
    required init(coder aDecoder: NSCoder) {
        // properties
        super.init(coder: aDecoder)!
        self.popUpImage = UIImageView(frame: CGRectMake(0, 0, 100, 100))

        self.address = UILabel(frame: CGRectMake(0, 0, 100, 100))
        self.distance = UILabel(frame: CGRectMake(0, 0, 100, 100))
        self.time = UILabel(frame: CGRectMake(0, 0, 100, 100))
        self.buildingName = UILabel(frame: CGRectMake(0, 0, 100, 100))

        // Setup
        setup()
        
    }
    
    var overViewEnabled: Bool = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        if(overViewEnabled == false){
        let location = touches.first!.locationInView(self.imageView)
        print(location)
        
         if(location.x > CGFloat(xAry[2]) && location.x < CGFloat(xAry[3]) && location.y > CGFloat(yAry[3]) && location.y < CGFloat(yAry[4])){
            print("MLK")
            popUp("mlk")
        } else if(location.x > CGFloat(xAry[1]) && location.x < CGFloat(xAry[3]) && location.y > CGFloat(yAry[6]) && location.y < CGFloat(yAry[8])){
            print("YUH")
            popUp("yuh")
        } else if(location.x > CGFloat(xAry[6]) && location.x < CGFloat(xAry[11]) && location.y > CGFloat(yAry[10]) && location.y < CGFloat(yAry[12])){
            print("SP")
            popUp("sp")
        } else if(location.x > CGFloat(xAry[12]) && location.x < CGFloat(xAry[16]) && location.y > CGFloat(yAry[3]) && location.y < CGFloat(yAry[5])){
            print("Eng")
            popUp("eng")
        } else if(location.x > CGFloat(xAry[12]) && location.x < CGFloat(xAry[18]) && location.y > CGFloat(yAry[5]) && location.y < CGFloat(yAry[6])){
            print("SU")
            popUp("su")
        } else if(location.x > CGFloat(xAry[19]) && location.y > CGFloat(yAry[5]) && location.y < CGFloat(yAry[7])){
            print("BBC")
            popUp("bbc")
        }
            overViewEnabled = true
        }
         else{
            self.sendSubviewToBack(popUpImage)
            overViewEnabled = false
            self.overlay.hidden = true
            self.buildingName.hidden = true
            self.address.hidden = true
            self.distance.hidden = true
            self.time.hidden = true
            self.buildingName.text = ""
            self.address.text = ""
            self.distance.text = ""
            self.time.text = ""
            
            
        }
    }
    
    func popUp(buildingName: String) {
        self.buildingName.hidden = false
        self.address.hidden = false
        self.distance.hidden = false
        self.time.hidden = false
        self.overlay.frame = self.frame
        self.overlay.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        self.overlay.hidden = false
        self.popUpImage.frame.origin.y = (self.view.bounds.size.height) / 2.0
        self.popUpImage.frame.origin.x = (self.view.bounds.size.width) / 2.0
        self.addSubview(popUpImage)
        
        
        switch(buildingName) {
        case "mlk":
            self.popUpImage.image = UIImage(named: "mlk")
            break

        case "yuh":
            self.popUpImage.image = UIImage(named: "yuh")
            break
        
        case "sp":
            self.popUpImage.image = UIImage(named: "sp")
            break
        
        case "eng":
            self.popUpImage.image = UIImage(named: "eng")
            break
        
        case "su":
            self.popUpImage.image = UIImage(named: "su")
            break
        
        case "bbc":
            self.popUpImage.image = UIImage(named: "bbc")
            break
        
        case "other":
            self.sendSubviewToBack(popUpImage)
            self.overlay.hidden = true
            break
        
        default:
            print("Default")
        }
        
        let dataAccess: DataAccess = DataAccess()
        let buildingActualAdd = dataAccess.getAddressForBuildingName(buildingName)

        self.buildingNameText = buildingActualAdd
        self.buildingNameSmall = buildingName
        self.getCurrentLocation(true)
        let data: DataObj = dataAccess.getDataObject(self.buildingNameSmall)
        self.buildingName.text = data.getBuildingName()
        self.address.text = data.getAddress()
        self.address.numberOfLines = 0
        self.buildingName.numberOfLines = 0
        
        self.buildingName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        self.address.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        self.distance.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        self.time.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        self.buildingName.textColor = UIColor.whiteColor()
        self.address.textColor = UIColor.whiteColor()
        self.distance.textColor = UIColor.whiteColor()
        self.time.textColor = UIColor.whiteColor()
        self.buildingName.layer.frame = CGRectMake(self.popUpImage.frame.origin.x + 105,self.popUpImage.frame.origin.y , 250, 20)
        self.address.layer.frame = CGRectMake(self.popUpImage.frame.origin.x + 105,self.popUpImage.frame.origin.y + 20, 250, 50)
        self.distance.layer.frame = CGRectMake(self.popUpImage.frame.origin.x + 105,self.popUpImage.frame.origin.y + 70 , 200, 20)
        self.time.layer.frame = CGRectMake(self.popUpImage.frame.origin.x + 105,self.popUpImage.frame.origin.y + 85 , 100, 20)
        
        self.addSubview(self.distance)
        self.addSubview(self.address)
        self.addSubview(self.buildingName)
        self.addSubview(self.time)
        self.distance.text = "Calculating..."
        
    }
    
    func setup() {
        view = loadViewFromNib()
        self.overlay.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.addSubview(view)
        var i : Float = 0.0
        var j : Float = 0.05
        for(i=1;i<21;i++) {
            xAry.append(Float(self.imageView.frame.width) * Float(j))
            yAry.append(Float(self.imageView.frame.height) * Float(j))
            j = j + 0.05
        }
        print(xAry.description)
        print(yAry.description)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
/*====================================Google Maps================================================*/
    
    var buildingKey: String = ""
    let SEPERATOR: String = ","
    var durationValue: String = ""
    var distanceValue: String = ""
    var i = 0
    
    
    func getBuildingCordinatesForAddress(address: String, origin: CLLocationCoordinate2D) {
        
        let addressEncode: String = address.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        var buildingLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let urlString: String = "http://maps.google.com/maps/api/geocode/json?address=" + addressEncode + "&sensor=false"
                guard let url = NSURL(string: urlString)
                    else {
                        print("Error: cannot create URL")
                        return
                }
        
                let urlRequest = NSURLRequest(URL: url)
                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: config)
                session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
                    guard let responseData = data else {
                        print("Error: did not receive data")
                        return
                    }
                    guard error == nil else {
                        print("error calling GET on /posts/1")
                        print(error)
                        return
                    }
                    
                    let post: NSDictionary
                    do {
                        post = try NSJSONSerialization.JSONObjectWithData(responseData,
                            options: []) as! NSDictionary
                    } catch  {
                        print("error trying to convert data to JSON")
                        return
                    }
                    
                    
                    let result = post["results"] as! [NSDictionary]
                    let firstObject = result[0]
                    let geometry = firstObject["geometry"] as! NSDictionary
                    let location = geometry["location"] as! NSDictionary
                    buildingLocation.latitude = location["lat"] as! Double
                    buildingLocation.longitude = location["lng"] as! Double
                    self.calculateDistance(origin, destination: buildingLocation)
                    
                }).resume()
        
     }
    
    func calculateDistance(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> [String : String] {
        
        var result: [String:String] = NSDictionary() as! [String : String]
        let originLat = String(origin.latitude)
        let originLng = String(origin.longitude)
        let destLat = String(destination.latitude)
        let destLng = String(destination.longitude)
        let urlString: String = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
            + originLat + SEPERATOR + originLng + "&destinations="
            + destLat + SEPERATOR + destLng + "&mode=walking&language=fr-FR&key=" + GoogleMap.API_KEY
//        
//                guard let url = NSURL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=37.316809269,-121.910686626&destinations=37.3351424,-121.88127580000003&mode=walking&language=fr-FR&key=AIzaSyDqd0KFSk00oT-8Zf-PQA5vZsShPYbstVg")
        
        guard let url = NSURL(string: urlString)
            else {
                print("Error: cannot create URL")
                return result
        }
        let urlRequest = NSURLRequest(URL: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
            let rows = post["rows"] as! [NSDictionary]
            let rowOne = rows[0]
            let elements = rowOne["elements"] as! [NSDictionary]
            let elementOne = elements[0]
            let distance1 = elementOne["distance"] as! NSDictionary
            let duration = elementOne["duration"] as! NSDictionary
            
            if let postTitle = post["title"] as? String {
                print("The title is: " + postTitle)
            }
            
            let dist = duration["text"] as! String
            let tim = distance1["text"] as! String
            dispatch_async(dispatch_get_main_queue(), {
                self.distance.text =  "\(dist)"
                self.time.text = "\(tim)"
            })
            
        })
        task.resume()
        return result
    }
}
