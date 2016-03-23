//
//  Item.swift
//  ArcticRun-iPad
//
//  Created by Anthony on 2016-03-03.
//  Copyright © 2016 COMP 4977. All rights reserved.
//

import Foundation
import CloudKit

public class Item{
    static let publicDB:CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    
    var record: CKRecord?
    
    init(itemRecord: CKRecord) {
        self.record = itemRecord
    }
    
    //TODO: Define some contants for item types
    init(amount:Int, member:CKReference, itemType: String){
        self.record = CKRecord(recordType: "Item")
        
        self.record!.setObject(amount, forKey: "amount")
        self.record!.setObject(member, forKey: "member")
        self.record!.setObject(itemType, forKey: "itemType")
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
    
    func getItemType() -> String? {
        return self.record?.objectForKey("itemType") as? String
    }
    
    func setItemType(itemType: String) -> Void {
        self.record?.setObject(itemType, forKey: "itemType")
    }
    
    static func getItems(memberRecord: CKRecord, onComplete: ([Item]) -> Void) -> Void {
        let predicate:NSPredicate = NSPredicate(format: "member == %@", memberRecord)
        let query:CKQuery = CKQuery(recordType: "Item", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return  //nothing
            }
            
            var items:[Item] = []
            for var i = 0; i < records?.count; i++ {
                let item:Item = Item(itemRecord: records![i])
                items.append(item)
            }
            
            onComplete(items)
        }
    }
    
    static func getAllItems(onComplete: ([Item]) -> Void) -> Void{
        let predicate:NSPredicate = NSPredicate(value: true)
        let query:CKQuery = CKQuery(recordType: "Item", predicate: predicate)
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return //found errors
            }
            
            var items:[Item] = []
            for var i = 0; i < records?.count; i++ {
                let item:Item = Item(itemRecord: records![i])
                items.append(item)
            }
            
            onComplete(items)
        }
    }
}