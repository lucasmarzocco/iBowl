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
    @IBOutlet weak var datePicker: UIDatePicker!
    var wordField1: UITextField?
    var wordField2: UITextField?
    var wordField3: UITextField?
    @IBOutlet weak var lanePattern: UITextField!
    @IBOutlet weak var type: UILabel!
    var league = ""
    var scores: [Int] = []
    var info: String = ""
    var average: Int = 0
    var lort: String = ""
    
    override func viewDidLoad() {
        datePicker.setValue(UIColor.red, forKeyPath: "textColor")
        type.text = league
        print("Editing info for league: " + self.league)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewScoreViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        print(league)
        print(date)
        /**let ref = FIRDatabase.database().reference(fromURL: "https://ibowl-c7e9e.firebaseio.com/" + deviceID + "/" + league + "/" + date)
        
        if ref =! nil {
        
            ref.observeSingleEvent(of: .value, with: { snapshot in
                var db = snapshot.value as! [String : AnyObject]
            
                for item in db["scores"] as! Array<AnyObject> {
                    self.scores.append(Int(item as! NSNumber))
                }
                self.tableView.reloadData()
            })
        } */
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    @objc func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as UITableViewCell
        cell.textLabel?.text = String(self.scores[(indexPath as NSIndexPath).row])
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if self.lanePattern.text! == "" {
            sendAlert("ERROR", message: "Pattern empty!")
            return false
        }
        if self.scores.count == 0 {
            sendAlert("ERROR", message: "No scores entered!")
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dest: StatsViewController = segue.destination as! StatsViewController
        dest.average = self.average
        dest.scores = self.scores
        dest.date = dateFormatter.string(from: datePicker.date)
        dest.type = self.type.text!
        dest.lanePattern = self.lanePattern.text!
        dest.league = self.league
        print("WHAT THE FUCK IS THE LORT???" + self.lort)
        dest.lort = self.lort
    }
    
    func sendAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
