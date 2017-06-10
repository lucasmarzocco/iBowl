//
//  Score.swift
//  iBowl
//
//  Created by Lucas Marzocco on 6/9/17.
//  Copyright © 2017 Lucas Marzocco. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Scores {
    
    let scores: [NSNumber]
    
    init(snapshot: FIRDataSnapshot) {
        
        scores = snapshot.value as! [NSNumber]
    }
}
