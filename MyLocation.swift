//
//  MyLocation.swift
//  Lab3
//
//  Created by Rishabh Sanghvi on 11/10/15.
//  Copyright © 2015 Rishabh Sanghvi. All rights reserved.
//

import UIKit

class MyLocation: UIViewController {
    
    @IBOutlet weak var mapView: UIImageView!
    var longitude : Double!
    var lattitude : Double!

    @IBOutlet weak var scView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
         
        if(longitude == nil || self.longitude == 0.0) {
            self.longitude = 121.884945
            self.lattitude = 37.335594
        }
                let x = Double(mapView.frame.width) * (fabs(self.longitude) - 121.886478) / (121.876243 - 121.886478)
                let y = Double(mapView.frame.height) - (Double(mapView.frame.height) * (fabs(self.lattitude) - 37.331361)/(37.338800 - 37.331361))
        print("X \(x)")
                print("Y \(y)")
        let point : CGPoint = CGPointMake(CGFloat(x), CGFloat(y));
      
        
        let xStart : Int = Int(point.x);
        let yStart : Int = Int(point.y);
        
        let innerCircleRect : CGRect = CGRectMake(CGFloat(xStart), CGFloat(yStart), 20, 20);
        
        let innerCircleView : UIView = UIView(frame: innerCircleRect);
        innerCircleView.tag = 999;
        
        innerCircleView.backgroundColor = UIColor.redColor();
        innerCircleView.layer.cornerRadius = 10.0;
        self.view.addSubview(innerCircleView);
    
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
