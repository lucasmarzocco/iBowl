//
//  PastScoresController.swift
//  iBowl
//
//  Created by Lucas Marzocco on 6/29/16.
//  Copyright © 2016 Lucas Marzocco. All rights reserved.
//

import UIKit
import Firebase

class PastScoresController: UITableViewController {
    
    var ref = FIRDatabase.database().referenceFromURL("https://ibowl-c7e9e.firebaseio.com/")
    
    var data: [String : AnyObject] = [:]
    var dates: [String] = []
    var averages: [AnyObject] = []
    var highGames: [AnyObject] = []
    var strings: [String] = []
    
    override func viewDidLoad() {
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            if(snapshot.exists()) {
                
                self.data = snapshot.value as! [String : AnyObject]
                self.addToList()
            }
        })
    }
    
    func addToList() {
        
        let df = NSDateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        
        let myArrayOfTuples = data.sort{ df.dateFromString($0.0)!.compare(df.dateFromString($1.0)!) == .OrderedAscending}
        
        for item in myArrayOfTuples {
            
            self.dates.append(item.0)
            
            let db = data[item.0]
            
            if let avg = db!["average"] {
                
                if let hg = db!["highGame"] {
                    
                    if(avg != nil && hg != nil) {
                        
                        self.averages.append(avg!)
                        self.highGames.append(hg!)
                    }
                }
            }
        }
        
        self.formCells()
        tableView.reloadData()
    }
    
    func formCells() {
        
        for (index, element) in averages.enumerate() {
            
            let string = "Average: " + String(element) + " - High game: " + String(highGames[index])
            strings.append(string)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.sendAlert("Coming Soon!", message: "Functionality is coming soon!")
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        cell.textLabel?.text = String(self.dates[indexPath.row])
        cell.detailTextLabel!.text = String(self.strings[indexPath.row])
        return cell
    }
    
    //Alert function that shows pop up alerts to the user
    func sendAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
