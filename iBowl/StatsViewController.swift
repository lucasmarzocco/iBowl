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
    
    var average = 0
    var scores: [Int] = []
    var date: String = ""
    var threeGameSeriesInt = 0
    var fiveGameSeriesInt = 0
    var highGame = 0
    var db: [String: AnyObject] = [:]
    var storedAverages: [AnyObject] = []
    var stored3Series: [AnyObject] = []
    var stored5Series: [AnyObject] = []
    
    var ref = FIRDatabase.database().reference(fromURL: "https://ibowl-c7e9e.firebaseio.com/")
    
    @IBOutlet weak var averageScore: UILabel!
    @IBOutlet weak var threeGameSeries: UILabel!
    @IBOutlet weak var fiveGameSeries: UILabel!
    @IBOutlet weak var bestAverage: UILabel!
    @IBOutlet weak var bestSeries: UILabel!
    @IBOutlet weak var gameCount: UILabel!
    
    override func viewDidLoad() {
        
        self.setUpData()
    }
    
    func setUpData() {
        
        print("Setting up data...")
        
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
            
            if let avg = data!["average"] {
                
                if let threeGame = data!["3gameSeries"] {
                    
                    if let fiveGame = data!["5gameSeries"] {
                        
                        if(avg != nil && threeGame != nil && fiveGame != nil) {
                        
                            self.storedAverages.append(avg! as AnyObject)
                            self.stored3Series.append(threeGame! as AnyObject)
                            self.stored5Series.append(fiveGame! as AnyObject)
                        }
                    }
                }
            }
            
            threeGameSeriesInt = findGameSeries(3)
            fiveGameSeriesInt = findGameSeries(5)
            
            let findBestAverage = self.findBestAverage()
            let findBestThreeSeries = self.findBestSeries(3)
            let findBestFiveSeries = self.findBestSeries(5)
            
            gameCount.text = "Game count: \(scores.count)"
            averageScore.text = "Average is: \(average)"
            threeGameSeries.text = "3 game series is: " + String(threeGameSeriesInt)
            fiveGameSeries.text = "5 game series is: " + String(fiveGameSeriesInt)
            
            bestAverage.text = "Best Average: " + String(findBestAverage)
            bestSeries.text = "Best Series (3/5): " + String(findBestThreeSeries) + "/" + String(findBestFiveSeries)
            
            let bool1 = average > findBestAverage
            let bool2 = threeGameSeriesInt > findBestThreeSeries
            let bool3 = fiveGameSeriesInt > findBestFiveSeries
            
            if(bool1 && bool2 && bool3) {
                self.sendAlert("Congrats!", message: "New high average and series!")
            }
            else if(bool2 || bool3) {
                self.sendAlert("Congrats!", message: "New high series!")
                
            }
            else if(bool1) {
                self.sendAlert("Congrats!", message: "New high average!")
            }
            
            else {
                self.sendAlert("Submitted!", message: "Your scores for \(date) have been submitted!")
            }
            
            self.sendToFirebase()
        }
    }
    
    func findBestAverage() -> Int {
        
        var bestAvg = 0
        
        for item in storedAverages {
            
            if(item as! Int > bestAvg) {
                bestAvg = Int(item as! NSNumber)
            }
        }
        
        return bestAvg
    }
    
    
    func findBestSeries(_ gameNum: Int) -> Int {
        
        var seriesPicker: [AnyObject] = []
        var bestSeries = 0
        
        if(gameNum == 3) {
            seriesPicker = stored3Series
        }
        else {
            seriesPicker = stored5Series
        }
        
        for item in seriesPicker {
            
            if item as! Int > bestSeries {
                bestSeries = Int(item as! NSNumber)
            }
        }
        
        return bestSeries
    }
    
    func sendToFirebase() {
        
        ref.child(date).child("scores").setValue(scores)
        ref.child(date).child("average").setValue(average)
        ref.child(date).child("3gameSeries").setValue(threeGameSeriesInt)
        ref.child(date).child("5gameSeries").setValue(fiveGameSeriesInt)
        ref.child(date).child("highGame").setValue(highGame)
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
    
    //Alert function that shows pop up alerts to the user
    func sendAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
