//
//  CalculateScores.swift
//  iBowl
//
//  Created by lmarzocc on 6/4/18.
//  Copyright © 2018 Lucas Marzocco. All rights reserved.
//

import UIKit
import Foundation

class CalculateScores: UIViewController {
    
    @IBOutlet weak var game: UITextField!
    @IBOutlet weak var current_score: UILabel!
    @IBOutlet weak var max_score: UILabel!

    override func viewDidLoad() {
    }
    
    func get_game(_ new_game: [String]) -> (Int, Int,Int) {
        
        var score = 0
        var index = 0
        var frame_count = 0
        
        for _ in 0..<10 {
            
            if isStrike(new_game, index) {
                frame_count+=1
                score += 10 + strikeBonus(new_game, index)
                index += 1
            }
            else if isSpare(new_game, index) {
                frame_count+=1
                score += 10 + spareBonus(new_game, index)
                index += 2
            }
            else {
                if index < new_game.count {
                    frame_count+=1
                    score += sumOfRolls(new_game, index)
                    index += 2
                }
            }
        }

        return (index, score, frame_count)
    }
    
    @IBAction func calc_game(_ sender: Any) {
        
        var perfect_game: [String] = ["10", "10", "10", "10", "10", "10", "10", "10", "10", "10", "10", "10"]
        
        var new_game = convert_game(game).components(separatedBy: " ")
        new_game.remove(at: new_game.count - 1)
        
        if new_game[0] == "" {
            current_score.text = "Current Score: " + String(0)
            max_score.text = "Max Score: " + String(300)
        }
        else {
            let (_, score, frames) = get_game(new_game)
            
            print (String(frames) + " FRAMES DOWN!")
            for i in frames..<perfect_game.count {
                new_game.append(perfect_game[i])
            }
            
            current_score.text = "Current Score: " + String(score)
            let (_, score1, _) = get_game(new_game)
            max_score.text = "Max Score: " + String(score1)
        }
    }

    func convert_game(_ game: UITextField) -> String {
        
        var converted_game = ""
        var index = 0
        
        var scoresEntered = game.text?.components(separatedBy: " ")
        
        for frame in scoresEntered! {
            
            if frame == "X" {
                converted_game += "10 "
            }
            else if frame == "/" {
                let number = Int(10) - Int(scoresEntered![index-1])!
                converted_game += String(number) + " "
            }
            else if frame == "-" {
                converted_game += "0 "
            }
            else {
                converted_game += frame + " "
            }
            
            index += 1
        }
        return converted_game
    }
    
    func isStrike(_ game: [String], _ frame: Int) -> Bool {
        if frame < game.count {
            return Int(game[frame]) == 10
        }
        else {
            return false
        }
    }
    
    func isSpare(_ game: [String], _ frame: Int) -> Bool {
        return Int(sumOfRolls(game, frame)) == 10
    }
    
    func strikeBonus(_ game: [String], _ frame: Int) -> Int {
        return Int(sumOfRolls(game, frame+1))
    }
    
    func spareBonus(_ game: [String], _ frame: Int) -> Int {
        if frame + 2 < game.count {
            return Int(game[frame+2])!
        }
        else {
            return 0
        }
    }
    
    func sumOfRolls(_ game: [String], _ frame: Int) -> Int {
        var a = 0
        var b = 0
        
        if frame < game.count {
            a = Int(game[frame])!
        }
        if (frame+1) < game.count {
            b = Int(game[frame+1])!
        }
        return Int(a) + Int(b)
    }
}
