//
//  HealthKitHelper.swift
//  ArcticRunTemplate
//
//  Created by IOS_DEV_358922 on 2016-03-02.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitHelper {
    
    let storage = HKHealthStore()
    
    init()
    {
        checkAuthorization()
    }

    func checkAuthorization() -> Bool
    {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable()
        {
            
            //We can make variables here to what data we want to acquire
            //Right now its just steps and distance travelled
            let stepsCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
            let distance = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
            
            
            // We have to request each data type explicitly
            let readTypes = NSSet(array: [stepsCount!, distance!])
            
            
            // Now we can request authorization for step count data
            storage.requestAuthorizationToShareTypes(nil, readTypes: readTypes as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else
        {
            isEnabled = false
        }
        
        return isEnabled
    }
    
    func recentSteps(completion: (Double, NSError?) -> () )
    {
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let newDate = cal.startOfDayForDate(date)
        
        // From Midnight of today to right now
        let predicate = HKQuery.predicateForSamplesWithStartDate(newDate, endDate: NSDate(), options: .None)
        
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var steps: Double = 0
            
            if results?.count > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    steps = result.quantity.doubleValueForUnit(HKUnit.countUnit())
                }
            }
            
            
            completion(steps, error)
        }
        
        storage.executeQuery(query)
    }
    
    func recentDistance(completion: (Double, NSError?) -> () )
    {
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let newDate = cal.startOfDayForDate(date)
        
        // From Midnight of today to right now
        let predicate = HKQuery.predicateForSamplesWithStartDate(newDate, endDate: NSDate(), options: .None)
        
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var distance: Double = 0
            
            if results?.count > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    distance = result.quantity.doubleValueForUnit(HKUnit.countUnit())
                }
            }
            
            
            completion(distance, error)
        }
        
        storage.executeQuery(query)
    }
    
}