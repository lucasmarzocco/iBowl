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
    var averages: [Int] = []
    var highGames: [Int] = []
    var strings: [String] = []
    
    override func viewDidLoad() {
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            self.data = snapshot.value as! [String : AnyObject]
            self.addToList()
        })
    }
    
    func addToList() {
        
        for item in data.keys {
            
            self.dates.append(item)
            let db = data[item]
            
            let avg = db!["average"] as! Int
            let hg = db!["highGame"] as! Int
            
            self.averages.append(avg)
            self.highGames.append(hg)
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
}
