//
//  Resource.swift
//  ArcticRun-iPad
//
//  Created by Anthony on 2016-03-03.
//  Copyright © 2016 COMP 4977. All rights reserved.
//

import Foundation
import CloudKit

public class Resource {
    static let publicDB:CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    
    var record:CKRecord?
    
    init(resourceRecord: CKRecord) {
        self.record = resourceRecord
    }
    
    //TODO define some constants for resourceType
    init(amount:Int, crew:CKReference, resourceType:String) {
        self.record = CKRecord(recordType: "Resource")
        
        self.record!.setObject(amount, forKey: "amount")
        self.record!.setObject(crew, forKey: "crew")
        self.record!.setObject(resourceType, forKey: "resourceType")
    }
    
    func getAmount() -> Int? {
        return self.record?.objectForKey("amount") as? Int
    }
    
    func setAmount(amount:Int) -> Void {
        self.record?.setObject(amount, forKey: "amount")
    }
    
    func getCrew() -> CKReference? {
        return self.record?.objectForKey("crew") as? CKReference
    }
    
    func setCrew(crew: CKReference) -> Void {
        self.record?.setObject(crew, forKey: "crew")
    }
    
    func getResourceType() -> String? {
        return self.record?.objectForKey("resourceType") as? String
    }
    
    func setResourceType(resourceType: String) -> Void {
        self.record?.setObject(resourceType, forKey: "resourceType")
    }
    
    
    static func getResources(crewRecord: CKRecord, onComplete: ([Resource]) -> Void) -> Void {
        let predicate:NSPredicate = NSPredicate(format: "crew == %@", crewRecord)
        let query:CKQuery = CKQuery(recordType: "Resource", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return  //nothing
            }
            
            var resources:[Resource] = []
            for var i = 0; i < records?.count; i++ {
                let resource:Resource = Resource(resourceRecord: records![i])
                resources.append(resource)
            }
            
            onComplete(resources)
        }
    }
    
    static func getAllResources(onComplete: ([Resource]) -> Void) -> Void{
        let predicate:NSPredicate = NSPredicate(value: true)
        let query:CKQuery = CKQuery(recordType: "Resource", predicate: predicate)
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return //found errors
            }
            
            var resources:[Resource] = []
            for var i = 0; i < records?.count; i++ {
                let resource:Resource = Resource(resourceRecord: records![i])
                resources.append(resource)
            }
            
            onComplete(resources)
        }
    }
    
}
