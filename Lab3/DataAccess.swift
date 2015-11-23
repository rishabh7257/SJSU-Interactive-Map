//
//  DataAccess.swift
//  Lab3
//
//  Created by Rishabh Sanghvi on 11/4/15.
//  Copyright © 2015 Rishabh Sanghvi. All rights reserved.
//

import Foundation


class DataAccess : NSObject {
    
    var data: [String:[String:String]]! = ["mlk":["name":"King Library","building":"Dr. Martin Luther King, Jr. Library, 150 East San Fernando Street, San Jose, CA 95112"],
    "eng":["name":"Engineering Building","building":"San José State University Charles W. Davidson College of Engineering, 1 Washington Square, San Jose, CA 95112"],
    "yuh":["name":"Yoshihiro Uchida Hall","building":"Yoshihiro Uchida Hall, San Jose, CA 95112"],
        "bbc":["name":"BBC","building":"Boccardo Business Complex, San Jose, CA 95112"],
        "su":["name":"Student Union","building":"Student Union Building, San Jose, CA 95112"],
        "sp":["name":"South​P​arking​G​arage","building":"San Jose State University South Garage, 330 South 7th Street, San Jose, CA 95112"]
    ]
    
    func getData(buildingName: String) -> [String:String] {
        return self.data[buildingName]!
    }
    
    func getDataObject(buildingName: String) -> DataObj! {
        let data: DataObj! = DataObj()
        let extractedValue = getData(buildingName)
        data.setBuildingName(extractedValue["name"]!)
        data.setAddress(extractedValue["building"]!)
        return data
    }
    
    func getAllBuildingDataObject() -> [DataObj]! {
        var results: [DataObj]! = [DataObj]()
        for (_,value) in self.data {
            let result: DataObj = DataObj()
            result.setBuildingName(value["name"]!)
            result.setAddress(value["building"]!)
            results.append(result)
        }
        return results
    }
    
    func getAddressForBuildingName(buildingName: String) -> String {
        let data: DataObj! = DataObj()
        let extractedValue = getData(buildingName)
        data.setBuildingName(extractedValue["name"]!)
        data.setAddress(extractedValue["building"]!)
        return data.getAddress()
    }
}