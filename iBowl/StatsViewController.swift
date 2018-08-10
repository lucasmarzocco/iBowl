//
//  StatsViewController.swift
//  iBowl
//
//  Created by Lucas Marzocco on 6/22/16.
//  Copyright © 2016 Lucas Marzocco. All rights reserved.
//

import UIKit
import Firebase

class StatsViewController: ViewController {
    
    var ref: FIRDatabaseReference!
    var ref1: FIRDatabaseReference!
    var average = 0
    var scores: [Int] = []
    var date: String = ""
    var gameSeriesInt = 0
    var runningAvg = 0
    var db: [String: AnyObject] = [:]
    var storedLeagueAverages: [AnyObject] = []
    var storedLeague3Series: [AnyObject] = []
    var type: String = ""
    var lanePattern: String = ""
    var league: String = ""
    
    @IBOutlet weak var today_average: UILabel!
    @IBOutlet weak var today_series: UILabel!
    @IBOutlet weak var best_average_league: UILabel!
    @IBOutlet weak var best_series_league: UILabel!
    @IBOutlet weak var running_avg_league: UILabel!
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference(fromURL: "https://ibowl-c7e9e.firebaseio.com/")
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.setUpData()
    }
    
    func setUpData() {
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        ref1 = FIRDatabase.database().reference(fromURL: "https://ibowl-c7e9e.firebaseio.com/" + deviceID + "/" + league)
        ref1.observeSingleEvent(of: .value, with: { snapshot in
            
            if(snapshot.exists()) {
                self.db = snapshot.value as! [String : AnyObject]
                self.addToList()
            }
            else {
                self.gameSeriesInt = self.findGameSeries()
                self.today_average.text = "Today's Average is: \(self.average)"
                self.today_series.text = "Today's series is: " + String(self.gameSeriesInt)
                self.sendAlert("Submitted!", message: "Your scores for \(self.date) have been submitted!")
                self.sendToFirebase()
                
            }
        })
    }
    
    func addToList() {
        for item in db.keys {
            
            let data = db[item]
            let avg = data!["average"]
            let threeGame = data!["3gameSeries"]
            self.storedLeagueAverages.append(avg! as AnyObject)
            self.storedLeague3Series.append(threeGame! as AnyObject)
        }
        
        gameSeriesInt = findGameSeries()
        let findBestLeagueAverage = self.findBestAverage(list: storedLeagueAverages)
        let findBestLeagueThreeSeries = self.findBestSeries(series: storedLeague3Series)
        let runningLeagueAvg = self.findRunningAverage(list: storedLeagueAverages)
        
        today_average.text = "Today's Average is: \(average)"
        today_series.text = "Today's series is: " + String(gameSeriesInt)
        best_average_league.text = "Best Average: " + String(findBestLeagueAverage)
        best_series_league.text = "Best Series: " + String(findBestLeagueThreeSeries)
        running_avg_league.text = "Running Avg: " + String(runningLeagueAvg)
        
        self.sendAlert("Submitted!", message: "Your scores for \(date) have been submitted!")
        self.sendToFirebase()
    }
    
    func findRunningAverage(list: [AnyObject]) -> Int {
        var value = 0
        var count = 0
        
        for avg in list {
            
            value += (avg as! Int)
            count += 1
        }
        
        if count == 0 {
            count = 1
        }
        
        return (value/count)
    }
    
    func findBestAverage(list: [AnyObject]) -> Int {
        var bestAvg = 0
        for item in list {
            
            if(item as! Int > bestAvg) {
                bestAvg = Int(truncating: item as! NSNumber)
            }
        }
        
        return bestAvg
    }
    
    func findBestSeries(series: [AnyObject]) -> Int {
        
        var bestSeries = 0
        
        for item in series {
            
            if item as! Int > bestSeries {
                bestSeries = Int(truncating: item as! NSNumber)
            }
        }
        
        return bestSeries
    }
    
    func findGameSeries() -> Int {
        return scores.reduce(0, +)
    }
    
    func findHighGame() -> Int {
        return scores.max()!
    }
    
    func sendToFirebase() {
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        ref.child(deviceID).child(league).child(date).child("scores").setValue(scores)
        ref.child(deviceID).child(league).child(date).child("average").setValue(average)
        ref.child(deviceID).child(league).child(date).child("3gameSeries").setValue(gameSeriesInt)
        ref.child(deviceID).child(league).child(date).child("highGame").setValue(findHighGame())
        ref.child(deviceID).child(league).child(date).child("classification").setValue("League")
        ref.child(deviceID).child(league).child(date).child("pattern").setValue(lanePattern)
    }
    
    func sendAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
