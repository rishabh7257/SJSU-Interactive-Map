//
//  SearchViewController.swift
//  Lab3
//
//  Created by Rishabh Sanghvi on 11/5/15.
//  Copyright © 2015 Rishabh Sanghvi. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataAccess = DataAccess()
    var buildingList: [DataObj] = [DataObj]()
    var filteredBuildingList: [DataObj] = [DataObj]()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildingList = dataAccess.getAllBuildingDataObject()
        //self.tableView.backgroundView = UIImageView(image: UIImage(named: "campusmap"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
            return self.filteredBuildingList.count
        }
        else
        {
            return self.buildingList.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        var buildingObj: DataObj!
        
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
            buildingObj = self.filteredBuildingList[indexPath.row]
        }
        else
        {
            buildingObj = self.buildingList[indexPath.row]
        }
        
        cell.textLabel?.text = buildingObj.getBuildingName()
        //cell.backgroundColor = UIColor.clearColor()
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var buildingObj: DataObj!
        
        if (tableView == self.searchDisplayController?.searchResultsTableView) {
            buildingObj = self.filteredBuildingList[indexPath.row]
        }
        else {
            buildingObj = self.buildingList[indexPath.row]
        }
        
        print(buildingObj.getBuildingName())
        let vc: ViewController = {
            return self.storyboard?.instantiateViewControllerWithIdentifier("mapVc") as! ViewController
        }()
       self.navigationController?.popToRootViewControllerAnimated(true)
    //    self.presentViewController(vc, animated: true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: buildingObj)
        
        
    }
    
    // MARK: - Search Methods
    
    func filterContenctsForSearchText(searchText: String, scope: String = "Title") {
        
        self.filteredBuildingList = self.buildingList.filter({( dataObj : DataObj) -> Bool in
            
            let categoryMatch = (scope == "Title")
            let stringMatch = dataObj.getBuildingName().rangeOfString(searchText)
            
            return categoryMatch && (stringMatch != nil)
            
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        
        self.filterContenctsForSearchText(searchString!, scope: "Title")
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        
        self.filterContenctsForSearchText(self.searchDisplayController!.searchBar.text!, scope: "Title")
        return true
    }
}
