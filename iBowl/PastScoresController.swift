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
    
    var ref = FIRDatabase.database().referenceFromURL("https://ibowl-c7e9e.firebaseio.com")
    
    //var scores: [String] = ["6/7/2016", "6/10/2016", "6/14/2016", "6/27/2016"]
    //var wow: [String] = ["Average: 202 - High game: 220", "Average: 206 - High game: 300", "Average: 210 - High game: 200", "Average: 202 - High game: 189" ]
    
    var dates: [String] = []
    
    override func viewDidLoad() {
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            let postDict = snapshot.value as! [String : AnyObject]
            
            for item in postDict.keys {
                print(item)
                
                self.dates.append(item)
            }
        })
        
        print(self.dates)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        cell.textLabel?.text = String(self.dates[indexPath.row])
        cell.detailTextLabel!.text = String(self.dates[indexPath.row])
        return cell
    }
    
    

}
