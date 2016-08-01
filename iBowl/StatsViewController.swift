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
    
    var ref = FIRDatabase.database().referenceFromURL("https://project-8644039570270742781.firebaseio.com/")
    
    @IBOutlet weak var averageScore: UILabel!
    @IBOutlet weak var threeGameSeries: UILabel!
    @IBOutlet weak var fiveGameSeries: UILabel!
    @IBOutlet weak var bestAverage: UILabel!
    @IBOutlet weak var bestSeries: UILabel!
    @IBOutlet weak var gameCount: UILabel!
    
    override func viewDidLoad() {
        
        gameCount.text = "Game count: \(scores.count)"
        averageScore.text = "Average is: \(average)"
        threeGameSeries.text = findGameSeries(3)
        fiveGameSeries.text = findGameSeries(5)
        bestAverage.text = "Best Average: Fill in here"
        bestSeries.text = "Best Series (3/5): 100/50"
        
        self.sendAlert("Submitted!", message: "Your scores for \(date) have been submitted!")
        
        self.sendToFirebase()
    }
    
    func sendToFirebase() {
        
        print(ref.description())
        print(ref.database)
        
        ref.setValue(scores)
        
    }
    
    func resetGames() {
        
        for score in scores {
            if(score < 0) {
                let index = scores.indexOf(score)!
                scores[index] = scores[index] * -1
                
            }
        }
    }
    
    func findGameSeries(gameCount: Int) -> String {
        
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
                    index = scores.indexOf(max)!
                }
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
        
        return "\(gameCount) game series: \(total)"
    }
    
    //Alert function that shows pop up alerts to the user
    func sendAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
