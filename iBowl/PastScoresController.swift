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
    
    var ref = FIRDatabase.database().reference(fromURL: "https://ibowl-c7e9e.firebaseio.com/")
    
    var data: [String : AnyObject] = [:]
    var dates: [String] = []
    var averages: [AnyObject] = []
    var highGames: [AnyObject] = []
    var strings: [String] = []
    
    override func viewDidLoad() {
        
        ref.observe(.value, with: { snapshot in
            
            if(snapshot.exists()) {
                
                self.data = snapshot.value as! [String : AnyObject]
                self.addToList()
            }
        })
    }
    
    func addToList() {
        
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        
        let myArrayOfTuples = data.sorted{ df.date(from: $0.0)!.compare(df.date(from: $1.0)!) == .orderedAscending}
        
        for item in myArrayOfTuples {
            
            self.dates.append(item.0)
            
            let db = data[item.0]
            
            if let avg = db!["average"] {
                
                if let hg = db!["highGame"] {
                    
                    if(avg != nil && hg != nil) {
                        
                        self.averages.append(avg! as AnyObject)
                        self.highGames.append(hg! as AnyObject)
                    }
                }
            }
        }
        
        self.formCells()
        tableView.reloadData()
    }
    
    func formCells() {
        
        for (index, element) in averages.enumerated() {
            
            //let string = "Average: " + (element as! String) + " - High game: " + (highGames[index] as! String)
            
            let string = "Average: \(element) - High game: \(highGames[index])"
            strings.append(string)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.sendAlert("Coming Soon!", message: "Functionality is coming soon!")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as UITableViewCell
        
        if((indexPath as NSIndexPath).row < self.dates.count) {
            cell.textLabel?.text = String(self.dates[(indexPath as NSIndexPath).row])
            cell.detailTextLabel!.text = String(self.strings[(indexPath as NSIndexPath).row])
        }
        
        return cell
    }
    
    //Alert function that shows pop up alerts to the user
    func sendAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
