//
//  NewScoreViewController.swift
//  iBowl
//
//  Created by Lucas Marzocco on 6/18/16.
//  Copyright © 2016 Lucas Marzocco. All rights reserved.
//

import UIKit
import Firebase

class NewScoreViewController: UIViewController {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var wordField1: UITextField?
    var wordField2: UITextField?
    var wordField3: UITextField?
    
    var scores: [Int] = []
    var info: String = ""
    var average: Int = 0
    
    override func viewDidLoad() {
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year, .Hour, .Minute, .Second], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        info = String(month) + "-" + String(day) + "-" + String(year)
        self.date.text = "Today is: " + info
        
    }
    
    @IBAction func addMultipleGames(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Add games", message: "Enter new games", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler ({ (textField: UITextField!) in
            textField.placeholder = "Ex: 197 178 167 145"
            self.wordField2 = textField })
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: gamesEntered))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func addNewGame(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Add game", message: "Enter new game", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler ({ (textField: UITextField!) in
            textField.placeholder = "Ex: 197"
            self.wordField1 = textField })
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: gameEntered))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeDate(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Submit previous date", message: "Enter new date", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler ({ (textField: UITextField!) in
            textField.placeholder = "Ex: 5-15-2010"
            self.wordField3 = textField })
        
        alert.addAction(UIAlertAction(title: "Change", style: UIAlertActionStyle.Default, handler: changeToPastDate))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func changeToPastDate(alert: UIAlertAction!) {
        
        info = (self.wordField3?.text)!
        self.date.text = "Entering games for: " + info
    }
    
    
    func gamesEntered(alert: UIAlertAction!) {
        
        let scoresEntered = (wordField2?.text)?.componentsSeparatedByString(" ")
        
        for score in scoresEntered! {
            if(checkValidGame(Int(score)!)) {
                scores.append(Int(score)!)
                tableView.reloadData()
            }
        }
    }
    
    func gameEntered(alert: UIAlertAction!) {
        
        let score = Int((wordField1?.text)!)!
        
        if(checkValidGame(score)) {
            scores.append(score)
            tableView.reloadData()
        }
    }
    
    func checkValidGame(game: Int)  -> Bool {
        return game >= 0 && game <= 300
    }

    @IBAction func calculateScores(sender: AnyObject) {
        
        if(scores.count == 0) {
            return
        }
        
        var totalScore = 0
        
        for game in scores {
            
            totalScore = totalScore + game
            
        }
        
        self.average = totalScore / scores.count
    }
    
    @IBAction func submitScores(sender: AnyObject) {
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        cell.textLabel?.text = String(self.scores[indexPath.row])
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let dest: StatsViewController = segue.destinationViewController as! StatsViewController
        dest.average = self.average
        dest.scores = self.scores
        dest.date = self.info
    }
}
