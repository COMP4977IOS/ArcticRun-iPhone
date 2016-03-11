//
//  CloudKitHelper.swift
//  ArcticRunTemplate
//
//  Created by IOS_DEV_358922 on 2016-03-09.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitHelper {
   
    func saveNote() -> () {
        var stepsToday: Double = 0
        var caloriesToday: Double = 0
        var distanceToday: Double = 0
        let tempUser = "_cb0ca9f34bf13ac0e8fc2b6ee4e2b6ad"
        
        HealthKitHelper().recentSteps() { steps, error in
            stepsToday = steps
        }
        
        HealthKitHelper().recentCaloriesBurned() { calories, error in
            caloriesToday = calories
        }
        
        HealthKitHelper().recentDistance() { distance, error in
            distanceToday = distance
        }
        
        let timestampAsString = String(format: "%f", NSDate.timeIntervalSinceReferenceDate())
        let timestampParts = timestampAsString.componentsSeparatedByString(".")
        
        let workoutID = CKRecordID(recordName: timestampParts[0])
        
        let workoutRecord = CKRecord(recordType: "Workout", recordID: workoutID)
        
        workoutRecord.setObject(caloriesToday, forKey: "caloriesBurned")
        workoutRecord.setObject(distanceToday, forKey: "distance")
        workoutRecord.setObject(stepsToday, forKey: "steps")
        workoutRecord.setObject(tempUser, forKey: "users")
        workoutRecord.setObject(NSDate(), forKey: "startDate")
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.saveRecord(workoutRecord, completionHandler: { (record, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                print("data sent!")
            }
        })
    }
}