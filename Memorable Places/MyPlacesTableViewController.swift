//
//  MyPlacesTableViewController.swift
//  Memorable Places
//
//  Created by Yu Andrew - andryu on 1/1/15.
//  Copyright (c) 2015 Andrew Yu. All rights reserved.
//

import UIKit

// global vars
var places: [[String:String]] = [[String:String]]()
var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

class MyPlacesTableViewController: UITableViewController {

    @IBAction func editPressed(sender: AnyObject) {
        tableView.setEditing(!tableView.editing, animated: true)
        (sender as UIBarButtonItem).title = tableView.editing ? "Done" : "Edit"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let temp = (userDefaults.objectForKey("places") as [[String:String]]?){
            places = temp
        } else {
            places = [
                ["name": "Golden Gate Bridge", "latitude": "37.820861", "longtitude": "-122.478148"],
                ["name": "Great Wall of China", "latitude": "40.432872", "longtitude": "116.570439"],
                ["name": "Statue of Liberty", "latitude": "40.690176", "longtitude": "-74.044479"]
            ]
            userDefaults.setObject(places, forKey: "places")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel?.text = places[indexPath.row]["name"]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        self.performSegueWithIdentifier("goToPlace", sender: cell)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextVC = segue.destinationViewController as ViewController
        if (segue.identifier == "goToPlace") {
            let row = self.tableView.indexPathForCell(sender as UITableViewCell)?.row
            nextVC.activePlace = places[row!]
        } else if (segue.identifier == "addPlace") {
            nextVC.manager.startUpdatingLocation()
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            places.removeAtIndex(indexPath.row)
            userDefaults.setObject(places, forKey: "places")
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

}
