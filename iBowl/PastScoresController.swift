//
//  PastScoresController.swift
//  iBowl
//
//  Created by Lucas Marzocco on 6/29/16.
//  Copyright © 2016 Lucas Marzocco. All rights reserved.
//

import UIKit

class PastScoresController: UITableViewController {
    
    var scores: [String] = ["6/7/2016", "6/10/2016", "6/14/2016", "6/27/2016"]
    var wow: [String] = ["Average: 202 - High game: 220", "Average: 206 - High game: 300", "Average: 210 - High game: 200", "Average: 202 - High game: 189" ]
    
    override func viewDidLoad() {
    
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        cell.textLabel?.text = String(self.scores[indexPath.row])
        cell.detailTextLabel!.text = String(self.wow[indexPath.row])
        return cell
    }
    
    

}
