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
    var games: [NSNumber] = []
    var type: String = ""
    var lanePattern: String = ""
    
    override func viewDidLoad() {
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
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

        let myArrayOfTuples = data.sorted{df.date(from: $0.0)!.compare(df.date(from: $1.0)!) == .orderedAscending}
        
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
            
            let string = "Average: \(element) - High game: \(highGames[index])"
            strings.append(string)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        let date = cell?.textLabel?.text ?? "01-01-2017"
        let url = "https://ibowl-c7e9e.firebaseio.com/" + date + "/scores"
        let url1 = "https://ibowl-c7e9e.firebaseio.com/" + date
        
        var classification = ""
        var lanePattern = ""
        
        let ref1 = FIRDatabase.database().reference(fromURL: url1)
        
        ref1.child("classification").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String {
                classification = item
            }
        })
        
        ref1.child("pattern").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String {
                lanePattern = item
            }
        })
        
        
        let ref = FIRDatabase.database().reference(fromURL: url)
        
        _ = ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let vars = Scores(snapshot: snapshot)
            
            var scoreString = ""
            var index = 1
            
            for val in vars.scores {
                scoreString += String(describing: val)
                
                if(index < vars.scores.count) {
                    scoreString += ", "
                }
                
                index += 1
                
            }
            
            let message = "Your " + String(vars.scores.count) + " games were: "
            self.sendAlert(classification + ": " + lanePattern, message: message + scoreString)
            
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as UITableViewCell
        
        cell.selectionStyle = .none
        
        if((indexPath as NSIndexPath).row < self.dates.count) && self.strings.count > 0 {
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
