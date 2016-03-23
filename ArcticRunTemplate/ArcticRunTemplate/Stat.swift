
//  Stat.swift
//  ArcticRun-iPad
//
//  Created by Anthony on 2016-03-03.
//  Copyright © 2016 COMP 4977. All rights reserved.
//

import Foundation
import CloudKit

public class Stat {
    static let publicDB:CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    
    var record:CKRecord?
    
    init(statRecord: CKRecord) {
        self.record = statRecord
    }
    
    //TODO: define some constants for statType
    init(amount:Int, member:CKReference, statType:String){
        self.record = CKRecord(recordType: "Stat")
        
        self.record!.setObject(amount, forKey: "amount")
        self.record!.setObject(member, forKey: "member")
        self.record!.setObject(statType, forKey: "statType")
    }
    
    func getAmount() -> Int? {
        return self.record?.objectForKey("amount") as? Int
    }
    
    func setAmount(amount:Int) -> Void {
        self.record?.setObject(amount, forKey: "amount")
    }
    
    func getMember() -> CKReference? {
        return self.record?.objectForKey("member") as? CKReference
    }
    
    func setMember(member:CKReference) -> Void {
        self.record?.setObject(member, forKey: "member")
    }
    
    func getStatType() -> String? {
        return self.record?.objectForKey("statType") as? String
    }
    
    func setStatType(statType: String) -> Void {
        self.record?.setObject(statType, forKey: "statType")
    }
    
    static func getStats(memberRecord: CKRecord, onComplete: ([Stat]) -> Void) -> Void {
        let predicate:NSPredicate = NSPredicate(format: "member == %@", memberRecord)
        let query:CKQuery = CKQuery(recordType: "Stat", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return  //nothing
            }
            
            var stats:[Stat] = []
            for var i = 0; i < records?.count; i++ {
                let stat:Stat = Stat(statRecord: records![i])
                stats.append(stat)
            }
            
            onComplete(stats)
        }
    }
    
    static func getAllStats(onComplete: ([Stat]) -> Void) -> Void{
        let predicate:NSPredicate = NSPredicate(value: true)
        let query:CKQuery = CKQuery(recordType: "Stat", predicate: predicate)
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return //found errors
            }
            
            var stats:[Stat] = []
            for var i = 0; i < records?.count; i++ {
                let stat:Stat = Stat(statRecord: records![i])
                stats.append(stat)
            }
            
            onComplete(stats)
        }
    }
    
}
