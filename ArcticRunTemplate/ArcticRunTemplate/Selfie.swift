//
//  Selfie.swift
//  ArcticRun-iPad
//
//  Created by Anthony on 2016-03-04.
//  Copyright © 2016 COMP 4977. All rights reserved.
//

import Foundation
import CloudKit

//TODO: Create some static constants
public class Selfie {
    static let publicDB:CKDatabase = CKContainer.defaultContainer().publicCloudDatabase     //TODO: This needs to be in some base class/interface
    
    var record:CKRecord?
    
    init(selfieRecord: CKRecord){
        self.record = selfieRecord
    }
    
    init(date:NSDate, image:CKAsset, user:CKReference) {
        self.record = CKRecord(recordType: "Selfie")
        
        self.record!.setObject(date, forKey: "date")
        self.record!.setObject(image, forKey: "image")
        self.record!.setObject(user, forKey: "user")
    }
    
    func getDate() -> NSDate? {
        return self.record?.objectForKey("date") as? NSDate
    }
    
    func setDate(date:NSDate) -> Void{
        self.record?.setObject(date, forKey: "date")
    }
    
    func getImage() -> CKAsset? {
        return self.record?.objectForKey("image") as? CKAsset
    }
    
    func setImage(image:CKAsset) -> Void {
        self.record?.setObject(image, forKey: "image")
    }
    
    func getUser() -> CKReference? {
        return record?.objectForKey("user") as? CKReference
    }
    
    func setUser(user: CKReference) -> Void {
        self.record?.setObject(user, forKey: "user")
    }
    
    func save() -> Void{
        Selfie.publicDB.saveRecord(self.record!) { (record: CKRecord?, error: NSError?) -> Void in
            if error == nil {
                print("record saved")
            }
        }
    }
    
    //TODO: try to make getXYZ and getAllXYZ to be generic functions for all similar classes
    static func getSelfies(userRecord: CKRecord, onComplete: ([Selfie]) -> Void) -> Void {
        let predicate:NSPredicate = NSPredicate(format: "user == %@", userRecord)
        let query:CKQuery = CKQuery(recordType: "Selfie", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return  //nothing
            }
            
            var selfies:[Selfie] = []
            for var i = 0; i < records?.count; i++ {
                let selfie:Selfie = Selfie(selfieRecord: records![i])
                selfies.append(selfie)
            }
            
            onComplete(selfies)
        }
    }
    
    static func getAllSelfies(onComplete: ([Selfie]) -> Void) -> Void{
        let predicate:NSPredicate = NSPredicate(value: true)
        let query:CKQuery = CKQuery(recordType: "Selfie", predicate: predicate)
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return //found errors
            }
            
            var selfies:[Selfie] = []
            for var i = 0; i < records?.count; i++ {
                let selfie:Selfie = Selfie(selfieRecord: records![i])
                selfies.append(selfie)
            }
            
            onComplete(selfies)
        }
    }
}
