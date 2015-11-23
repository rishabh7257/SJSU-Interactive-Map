//
//  GoogleMaps.swift
//  Lab3
//
//  Created by Rishabh Sanghvi on 11/6/15.
//  Copyright © 2015 Rishabh Sanghvi. All rights reserved.
//

import Foundation
import GoogleMaps

class GoogleMap : NSObject, CLLocationManagerDelegate {
     static let API_KEY: String = "AIzaSyDqd0KFSk00oT-8Zf-PQA5vZsShPYbstVg"
    
    var myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    var buildingKey: String = ""
    let SEPERATOR: String = ","
    var durationValue: String = ""
    var distanceValue: String = ""
    var i = 0
    
    
    func getBuildingCordinatesForAddress(address: String, completion: ((result:CLLocationCoordinate2D?) -> Void)!) {
        
        let sem: dispatch_semaphore_t = dispatch_semaphore_create(0)
        var buildingLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
       let urlString: String = "http://maps.google.com/maps/api/geocode/json?address=" + address + "&sensor=false"
//        guard let url = NSURL(string: urlString)
//            else {
//                print("Error: cannot create URL")
//                return buildingLocation
//        }
//
//        let urlRequest = NSURLRequest(URL: url)
//        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
//        let session = NSURLSession(configuration: config)
//        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { data, response, error) in
            if let url = NSURL(string: urlString) {
                NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in

            
            if ((data) != nil) {
                let post: NSDictionary
                            do {
                                post = try NSJSONSerialization.JSONObjectWithData(data!,
                                    options: []) as! NSDictionary
                            } catch  {
                                print("error trying to convert data to JSON")
                                return
                            }

                
                
                //            let firstObject = result[0]
                //            let geometry = firstObject["geometry"] as! NSDictionary
                //            let location = geometry["location"] as! NSDictionary
                //            buildingLocation.latitude = location["lat"] as! Double
                //            buildingLocation.longitude = location["lng"] as! Double
                if let result = post["results"] as? [NSDictionary] {
                    let firstObject = result[0]
                    if let geometry = firstObject["geometry"] as? NSDictionary {
                        if let location = geometry["location"] as? NSDictionary {
                            buildingLocation.latitude = location["lat"] as! Double
                            buildingLocation.longitude = location["lng"] as! Double
                            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                                dispatch_async(dispatch_get_main_queue()) {
                                    completion(result: buildingLocation)
                                }
                            }
                            
                        }
                    }
                }
            }
            else {
                completion(result: nil)
            }
            
            }.resume()
//            
//            guard let responseData = data else {
//                print("Error: did not receive data")
//                return
//            }
//            guard error == nil else {
//                print("error calling GET on /posts/1")
//                print(error)
//                return
//            }
//            
//            let post: NSDictionary
//            do {
//                post = try NSJSONSerialization.JSONObjectWithData(responseData,
//                    options: []) as! NSDictionary
//            } catch  {
//                print("error trying to convert data to JSON")
//                return
//            }
//            
//            
//            let result = post["results"] as! [NSDictionary]
//            let firstObject = result[0]
//            let geometry = firstObject["geometry"] as! NSDictionary
//            let location = geometry["location"] as! NSDictionary
//            buildingLocation.latitude = location["lat"] as! Double
//            buildingLocation.longitude = location["lng"] as! Double
//            dispatch_semaphore_signal(sem)
//        })
//            task.resume()
//        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
//        return buildingLocation
    }
    }
    
    func calculateDistance(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> [String : String] {
        
        var result: [String:String] = NSDictionary() as! [String : String]
        let originLat = String(origin.latitude)
        let originLng = String(origin.longitude)
        let destLat = String(destination.latitude)
        let destLng = String(destination.latitude)
        let urlString: String = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
            + originLat + SEPERATOR + originLng + "&destination="
            + destLat + SEPERATOR + destLng + "&mode=walking&language=fr-FR&key=" + GoogleMap.API_KEY
        //
        //        guard let url = NSURL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=37.316809269,-121.910686626&destinations=37.3351424,-121.88127580000003&mode=walking&language=fr-FR&key=AIzaSyDqd0KFSk00oT-8Zf-PQA5vZsShPYbstVg")
        
        guard let url = NSURL(string: urlString)
            else {
                print("Error: cannot create URL")
                return result
        }
        let urlRequest = NSURLRequest(URL: url)
        //urlRequest.HTTPMethod = "GET"
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
            let distance = elementOne["distance"] as! NSDictionary
            let duration = elementOne["duration"] as! NSDictionary
            result["duration"] = String(duration["value"])
            result["distance"] = String(distance["value"])
            
            
            if let postTitle = post["title"] as? String {
                print("The title is: " + postTitle)
            }
        })
        task.resume()
        return result
    }
    
    

    
}
