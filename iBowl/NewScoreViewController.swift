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
        
        let date = Date()
        let calendar = NSCalendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day], from: date)
        
        let year =  components.year?.description
        let month = components.month?.description
        let day = components.day?.description
        
        info =  month! + "-" + day! + "-" + year!
        self.date.text = "Today is: " + info
        
    }
    
    @IBAction func addMultipleGames(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Add games", message: "Enter new games", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField (configurationHandler: { (textField: UITextField!) in
            textField.placeholder = "Ex: 197 178 167 145"
            self.wordField2 = textField })
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: gamesEntered))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addNewGame(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Add game", message: "Enter new game", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField (configurationHandler: { (textField: UITextField!) in
            textField.placeholder = "Ex: 197"
            self.wordField1 = textField })
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: gameEntered))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeDate(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Submit previous date", message: "Enter new date", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField (configurationHandler: { (textField: UITextField!) in
            textField.placeholder = "Ex: 5-15-2010"
            self.wordField3 = textField })
        
        alert.addAction(UIAlertAction(title: "Change", style: UIAlertActionStyle.default, handler: changeToPastDate))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeToPastDate(_ alert: UIAlertAction!) {
        
        info = (self.wordField3?.text)!
        self.date.text = "Entering games for: " + info
    }
    
    
    func gamesEntered(_ alert: UIAlertAction!) {
        
        let scoresEntered = (wordField2?.text)?.components(separatedBy: " ")
        
        for score in scoresEntered! {
            if(checkValidGame(Int(score)!)) {
                scores.append(Int(score)!)
                tableView.reloadData()
            }
        }
    }
    
    func gameEntered(_ alert: UIAlertAction!) {
        
        let score = Int((wordField1?.text)!)!
        
        if(checkValidGame(score)) {
            scores.append(score)
            tableView.reloadData()
        }
    }
    
    func checkValidGame(_ game: Int)  -> Bool {
        return game >= 0 && game <= 300
    }

    @IBAction func calculateScores(_ sender: AnyObject) {
        
        if(scores.count == 0) {
            return
        }
        
        var totalScore = 0
        
        for game in scores {
            
            totalScore = totalScore + game
            
        }
        
        self.average = totalScore / scores.count
    }
    
    @IBAction func submitScores(_ sender: AnyObject) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as UITableViewCell
        cell.textLabel?.text = String(self.scores[(indexPath as NSIndexPath).row])
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let dest: StatsViewController = segue.destination as! StatsViewController
        dest.average = self.average
        dest.scores = self.scores
        dest.date = self.info
    }
}
