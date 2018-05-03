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
    var average = 0
    var scores: [Int] = []
    var date: String = ""
    var threeGameSeriesInt = 0
    var highGame = 0
    var runningAvg = 0
    var db: [String: AnyObject] = [:]
    var storedCasualAverages: [AnyObject] = []
    var storedLeagueAverages: [AnyObject] = []
    var storedCasual3Series: [AnyObject] = []
    var storedLeague3Series: [AnyObject] = []
    var type: String = "League"
    var lanePattern: String = "House"
    
    @IBOutlet weak var today_average: UILabel!
    @IBOutlet weak var today_series: UILabel!
    @IBOutlet weak var best_average_league: UILabel!
    @IBOutlet weak var best_average_casual: UILabel!
    @IBOutlet weak var best_series_league: UILabel!
    @IBOutlet weak var running_avg_casual: UILabel!
    @IBOutlet weak var best_series_casual: UILabel!
    @IBOutlet weak var running_avg_league: UILabel!
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference(fromURL: "https://ibowl-c7e9e.firebaseio.com/")
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.setUpData()
    }
    
    func setUpData() {
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if(snapshot.exists()) {
                self.db = snapshot.value as! [String : AnyObject]
                self.addToList()
            }
        })
    }
    
    func addToList() {
        
        for item in db.keys {
            
            let data = db[item]
            
            let avg = data!["average"]
            let threeGame = data!["3gameSeries"]
            
            if (data!["classification"] as! String) == "League" {
                self.storedLeagueAverages.append(avg! as AnyObject)
                self.storedLeague3Series.append(threeGame! as AnyObject)
            }
            else {
                self.storedCasualAverages.append(avg! as AnyObject)
                self.storedCasual3Series.append(threeGame! as AnyObject)
            }
        }
    
        threeGameSeriesInt = findGameSeries(3)
        
        let findBestLeagueAverage = self.findBestAverage(list: storedLeagueAverages)
        let findBestCasualAverage = self.findBestAverage(list: storedCasualAverages)
        let findBestLeagueThreeSeries = self.findBestSeries(series: storedLeague3Series)
        let findBestCasualThreeSeries = self.findBestSeries(series: storedCasual3Series)
        let runningLeagueAvg = self.findRunningAverage(list: storedLeagueAverages)
        let runningCasualAvg = self.findRunningAverage(list: storedCasualAverages)
        
        today_average.text = "Today's Average is: \(average)"
        today_series.text = "Today's series is: " + String(threeGameSeriesInt)
        best_average_league.text = "Best Average (League): " + String(findBestLeagueAverage)
        best_average_casual.text = "Best Average (Casual): " + String(findBestCasualAverage)
        best_series_league.text = "Best Series (League): " + String(findBestLeagueThreeSeries)
        best_series_casual.text = "Best Series (Casual): " + String(findBestCasualThreeSeries)
        running_avg_league.text = "Running Avg (League): " + String(runningLeagueAvg)
        running_avg_casual.text = "Running Avg (Casual): " + String(runningCasualAvg)
        
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
    
    func resetGames() {
        
        for score in scores {
            if(score < 0) {
                let index = scores.index(of: score)!
                scores[index] = scores[index] * -1
                
            }
        }
    }
    
    func findGameSeries(_ gameCount: Int) -> Int {
        
        var series: [Int] = []
        var max: Int = 0
        var count: Int = 0
        var index: Int = 0
        var numOfGames: Int = 0
        
        if(scores.count >= gameCount) {
            numOfGames = gameCount
        }
        else {
            numOfGames = scores.count
        }
        
        while(count < numOfGames) {
        
            for score in scores {
            
                if(score > max) {
                    max = score
                    index = scores.index(of: max)!
                }
            }
            
            if(count == 0) {
                highGame = max
            }
            
            series.append(max)
            count = count + 1
            scores[index] = scores[index] * -1
            max = 0
            index = 0
            
        }
        
        var total: Int = 0
        
        for score in series {
            total = total + score
        }
        
        resetGames()
        return total
    }
    
    func sendToFirebase() {
        
        ref.child(date).child("scores").setValue(scores)
        ref.child(date).child("average").setValue(average)
        ref.child(date).child("3gameSeries").setValue(threeGameSeriesInt)
        ref.child(date).child("highGame").setValue(highGame)
        ref.child(date).child("classification").setValue(type)
        ref.child(date).child("pattern").setValue(lanePattern)
    }
    
    func sendAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
