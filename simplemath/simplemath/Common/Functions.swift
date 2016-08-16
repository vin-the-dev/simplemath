//
//  Functions.swift
//  simplemath
//
//  Created by Vineeth Vijayan on 14/08/16.
//  Copyright © 2016 creativelogics. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

func uploadAnalytics(num1: String, num2: String, action: String, result: String, reply: String){
    //                let userData: [String : AnyObject] = ["userName":  (user?.displayName)!,
    //                                                      "email": (user?.email)!]
    //
    //                self.usersRef.child((user?.uid)!).setValue(userData)
    
    //updating directly
    //self.usersRef.child((user?.uid)!).updateChildValues(["email": "test"])
    
    //updating with current value
    
    
    let scoresRef = FIRDatabase.database().reference().child("scores")
    
    if let uId = FIRAuth.auth()?.currentUser?.uid {
        scoresRef.child(uId).keepSynced(true)
        scoresRef.child(uId).child("score").keepSynced(true)
        scoresRef.child(uId).child("totalQuestions").keepSynced(true)
        
        scoresRef.child(uId).runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in

            var value = currentData.value as? [String : AnyObject]
            
            if value == nil {
                return FIRTransactionResult.success(withValue: currentData)
            }
            
            if result == reply {
                let scor = value!["score"] as? Int ?? 0
                value?["score"] =  scor + 1
            }
            
            let totQ = value!["totalQuestions"] as? Int ?? 0
            print(totQ)
            value?["totalQuestions"] =  totQ + 1
            
            currentData.value = value
            
            return FIRTransactionResult.success(withValue: currentData)
        })
    }
    
    
    
}
