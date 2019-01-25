//
//  TournamentViewController.swift
//  iBowl
//
//  Created by Lucas Marzocco on 1/24/19.
//  Copyright © 2019 Lucas Marzocco. All rights reserved.
//

import UIKit
import Firebase

class TournamentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    var wordField1: UITextField?
    var ref_tourns: FIRDatabaseReference!
    var data: [String : AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        
        ref_tourns = FIRDatabase.database().reference(fromURL: "https://ibowl-c7e9e.firebaseio.com/" + deviceID + "/Tournaments")
        ref_tourns.observe(.value, with: { snapshot in
            
            if(snapshot.exists()) {
                self.data = snapshot.value as! [String : AnyObject]
                print(self.data.keys)
                
                self.picker.dataSource = self
                self.picker.delegate = self
                
                for item in self.data.keys {
                    self.pickerData.append(item)
                }
            }
            
            self.pickerData = Array(Set(self.pickerData))
        })
        
        self.picker.dataSource = self
        self.picker.delegate = self
    }
    
    @IBAction func add_tournament(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Tournament", message: "Enter new Tournament", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField (configurationHandler: { (textField: UITextField!) in
            textField.placeholder = "Ex: USA Trials"
            self.wordField1 = textField })
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: tournamentEntered))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tournamentEntered(_ alert: UIAlertAction!) {
        
        pickerData.append((wordField1?.text)!)
        self.picker.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "addGame":
                let dest: NewScoreViewController = segue.destination as! NewScoreViewController
                dest.league = pickerData[picker.selectedRow(inComponent: 0)]
                dest.lort = "Tournaments"
            case "pastScores":
                let dest: PastScoresController = segue.destination as! PastScoresController
                dest.league = pickerData[picker.selectedRow(inComponent: 0)]
                dest.lort = "Tournaments"
            default:
                return
            }
        }
    }
}
