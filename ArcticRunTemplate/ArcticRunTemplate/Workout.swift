//
//  Workout.swift
//  ArcticRun-iPad
//
//  Created by Anthony on 2016-03-04.
//  Copyright © 2016 COMP 4977. All rights reserved.
//

import Foundation
import CoreLocation
import CloudKit

//TODO: refactor some constants out of this
public class Workout {
    static let publicDB:CKDatabase = CKContainer.defaultContainer().publicCloudDatabase //TODO: put this in an abstract base class?
    
    var record:CKRecord?
    
    init(workoutRecord: CKRecord){
        self.record = workoutRecord
    }

    init(caloriesBurned:Int, distance:Double, endDate:NSDate, fastestSpeed:Double, endLocation:CLLocation, startDate:NSDate, startLocation:CLLocation, steps: Int, user: CKReference) {
        self.record = CKRecord(recordType: "Workout")
        
        self.record!.setObject(caloriesBurned, forKey: "caloriesBurned")
        self.record!.setObject(distance, forKey: "distance")
        self.record!.setObject(endDate, forKey: "endDate")
        self.record!.setObject(endLocation, forKey: "endLocation")
        self.record!.setObject(fastestSpeed, forKey: "fastestSpeed")
        self.record!.setObject(startDate, forKey: "startDate")
        self.record!.setObject(startLocation, forKey: "startLocation")
        self.record!.setObject(steps, forKey: "steps")
        self.record!.setObject(user, forKey: "user")
    }
    
    func getCaloriesBurned() -> Double? {
        return record?.objectForKey("caloriesBurned") as? Double
    }
    
    func setCaloriesBurned(caloriesBurned: Int) -> Void {
        self.record?.setObject(caloriesBurned, forKey: "caloriesBurned")
    }
    
    func getDistance() -> Double? {
        return record?.objectForKey("distance") as? Double
    }
    
    func setDistance(distance: Double) -> Void {
        self.record?.setObject(distance, forKey: "distance")
    }
    
    func getEndDate() -> NSDate? {
        return record?.objectForKey("endDate") as? NSDate
    }
    
    func setEndDate(endDate: NSDate) -> Void {
        self.record?.setObject(endDate, forKey: "endDate")
    }
    
    func getEndLocation() -> CLLocation? {
        return record?.objectForKey("endLocation") as? CLLocation
    }
    
    func setEndLocation(endLocation:CLLocation) -> Void {
        self.record?.setObject(endLocation, forKey: "endLocation")
    }
    
    func getFastestSpeed() -> Double? {
        return record?.objectForKey("fastestSpeed") as? Double
    }
    
    func setFastestSpeed(fastestSpeed: Double) -> Void{
        self.record?.setObject(fastestSpeed, forKey: "fastestSpeed")
    }
    
    func getStartDate() -> NSDate? {
        return record?.objectForKey("startDate") as? NSDate
    }
    
    func setStartDate(startDate: NSDate) -> Void {
        self.record?.setObject(startDate, forKey: "startDate")
    }
    
    func getStartLocation() -> CLLocation? {
        return record?.objectForKey("startLocation") as? CLLocation
    }
    
    func setStartLocation(startLocation: CLLocation) -> Void {
        self.record?.setObject(startLocation, forKey: "startLocation")
    }
    
    func getSteps() -> Int? {
        return record?.objectForKey("steps") as? Int
    }
    
    func setSteps(steps:Int) -> Void {
        self.record?.setObject(steps, forKey: "steps")
    }
    
    func getUser() -> CKReference? {
        return record?.objectForKey("user") as? CKReference
    }
    
    func setUser(user: CKReference) -> Void {
        self.record?.setObject(user, forKey: "user")
    }
    
    func save() -> Void{
        Workout.publicDB.saveRecord(self.record!) { (record: CKRecord?, error: NSError?) -> Void in
            if error == nil {
                print("record saved")
            }
        }
    }
    
    //onComplete: closure for cool stuff
    static func getWorkouts(userRecord: CKRecord, onComplete: ([Workout]) -> Void) -> Void {
        let predicate:NSPredicate = NSPredicate(format: "user == %@", userRecord)
        let query:CKQuery = CKQuery(recordType: "Workout", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return  //nothing
            }
            
            var workouts:[Workout] = []
            for var i = 0; i < records?.count; i++ {
                let workout:Workout = Workout(workoutRecord: records![i])
                workouts.append(workout)
            }

            onComplete(workouts)
        }
    }
    
    static func getAllWorkouts(onComplete:([Workout]) -> Void) -> Void {
        let predicate:NSPredicate = NSPredicate(value: true)
        let query:CKQuery = CKQuery(recordType: "Workout", predicate: predicate)
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return //found errors
            }
            
            var workouts:[Workout] = []
            for var i = 0; i < records?.count; i++ {
                let workout:Workout = Workout(workoutRecord: records![i])
                workouts.append(workout)
            }
            
            onComplete(workouts)
        }
    }
}
