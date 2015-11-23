//
//  dataModel.swift
//  Lab3
//
//  Created by Rishabh Sanghvi on 11/4/15.
//  Copyright © 2015 Rishabh Sanghvi. All rights reserved.
//

import Foundation

class DataObj {
    var buildingName: String!
    var address: String!
    
    func setBuildingName(buildingName: String) {
        self.buildingName = buildingName
    }
    
    func setAddress(address: String) {
        self.address = address
    }
    
    func getBuildingName() -> String {
        return self.buildingName
    }
    
    func getAddress() -> String {
        return self.address
    }
    
}
