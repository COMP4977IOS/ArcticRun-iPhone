//
//  Member.swift
//  ArcticRun-iPad
//
//  Created by Anthony on 2016-03-03.
//  Copyright © 2016 COMP 4977. All rights reserved.
//

import Foundation
import CloudKit

public class Member {
    static let publicDB:CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    
    var record:CKRecord?
    
    init(memberRecord:CKRecord){
        self.record = memberRecord
    }
    
    init(crew: CKReference, diaries:[CKReference], firstName: String, items:[CKReference], lastName: String, stats:[CKReference], status: String){
        self.record = CKRecord(recordType: "Member")
        
        self.record!.setObject(crew, forKey: "crew")
        self.record!.setObject(diaries, forKey: "diary")
        self.record!.setObject(firstName, forKey: "firstName")
        self.record!.setObject(items, forKey: "item")
        self.record!.setObject(lastName, forKey: "lastName")
        self.record!.setObject(stats, forKey: "stat")
        self.record!.setObject(status, forKey: "status")
    }
    
    func getCrew() -> CKReference? {
        return self.record?.objectForKey("crew") as? CKReference
    }
    
    func setCrew(crew: CKReference) -> Void {
        self.record?.setObject(crew, forKey: "crew")
    }
    
    func getDiaries() -> [CKReference]? {
        return self.record?.objectForKey("diary") as? [CKReference]
    }
    
    func setDiaries(diaries: [CKReference]) -> Void {
        self.record?.setObject(diaries, forKey: "diary")
    }
    
    func getFirstName() -> String? {
        return self.record?.objectForKey("firstName") as? String
    }
    func setFirstName(firstName:String) -> Void{
        self.record?.setObject(firstName, forKey: "firstName")
    }
    
    func getItems() -> [CKReference]? {
        return self.record?.objectForKey("item") as? [CKReference]
    }
    
    func setItems(items: [CKReference]) -> Void {
        self.record?.setObject(items, forKey: "item")
    }
    
    func getLastName() -> String? {
        return self.record?.objectForKey("lastName") as? String
    }
    
    func setLastName(lastName: String) -> Void {
        self.record?.setObject(lastName, forKey: "lastName")
    }
    
    func getStats() -> [CKReference]? {
        return self.record?.objectForKey("stat") as? [CKReference]
    }
    
    func setStats(stats:[CKReference]) -> Void {
        self.record?.setObject(stats, forKey: "stat")
    }
    
    func getStatus() -> String? {
        return self.record?.objectForKey("status") as? String
    }
    
    func setStatus(status: String) -> Void {
        self.record?.setObject(status, forKey: "status")
    }
    
    static func getMembers(crewRecord: CKRecord, onComplete: ([Member]) -> Void) -> Void {
        let predicate:NSPredicate = NSPredicate(format: "user == %@", crewRecord)
        let query:CKQuery = CKQuery(recordType: "Member", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return  //nothing
            }
            
            var members:[Member] = []
            for var i = 0; i < records?.count; i++ {
                let member:Member = Member(memberRecord: records![i])
                members.append(member)
            }
            
            onComplete(members)
        }
    }
    
    static func getAllMembers(onComplete: ([Member]) -> Void) -> Void{
        let predicate:NSPredicate = NSPredicate(value: true)
        let query:CKQuery = CKQuery(recordType: "Member", predicate: predicate)
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return //found errors
            }
            
            var members:[Member] = []
            for var i = 0; i < records?.count; i++ {
                let member:Member = Member(memberRecord: records![i])
                members.append(member)
            }
            
            onComplete(members)
        }
    }
}
