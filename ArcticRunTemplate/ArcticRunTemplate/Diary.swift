//
//  Diary.swift
//  ArcticRun-iPad
//
//  Created by Anthony on 2016-03-03.
//  Copyright © 2016 COMP 4977. All rights reserved.
//

import Foundation
import CloudKit

public class Diary {
    static let publicDB:CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    
    var record:CKRecord?
    
    init(diaryRecord: CKRecord) {
        self.record = diaryRecord
    }
    
    init(audio:CKAsset, date:NSDate, member: CKReference, text:String){
        self.record = CKRecord(recordType: "Diary")
        
        self.record!.setObject(audio, forKey: "audio")
        self.record!.setObject(date, forKey: "date")
        self.record!.setObject(member, forKey: "member")
        self.record!.setObject(text, forKey: "text")
    }
    
    func getAudio() -> CKAsset? {
        return self.record?.objectForKey("audio") as? CKAsset
    }
    
    func setAudio(audio:CKAsset) -> Void {
        self.record?.setObject(audio, forKey: "audio")
    }
    
    func getDate() -> NSDate? {
        return self.record?.objectForKey("date") as? NSDate
    }
    
    func setDate(date:NSDate) -> Void{
        self.record?.setObject(date, forKey: "date")
    }
    
    func getMember() -> CKReference? {
        return self.record?.objectForKey("member") as? CKReference
    }
    
    func setMember(member:CKReference) -> Void {
        self.record?.setObject(member, forKey: "member")
    }
    
    func getText() -> String? {
        return self.record?.objectForKey("text") as? String
    }
    
    func setText(text:String) -> Void {
        self.record?.setObject(text, forKey: "text")
    }
    
    static func getDiaries(memberRecord: CKRecord, onComplete: ([Diary]) -> Void) -> Void {
        let predicate:NSPredicate = NSPredicate(format: "member == %@", memberRecord)
        let query:CKQuery = CKQuery(recordType: "Diary", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return  //nothing
            }
            
            var diaries:[Diary] = []
            for var i = 0; i < records?.count; i++ {
                let diary:Diary = Diary(diaryRecord: records![i])
                diaries.append(diary)
            }
            
            onComplete(diaries)
        }
    }
    
    static func getAllDiaries(onComplete: ([Diary]) -> Void) -> Void{
        let predicate:NSPredicate = NSPredicate(value: true)
        let query:CKQuery = CKQuery(recordType: "Diary", predicate: predicate)
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if error != nil || records == nil {
                return //nothing
            }
            
            var diaries:[Diary] = []
            for var i = 0; i < records?.count; i++ {
                let diary:Diary = Diary(diaryRecord: records![i])
                diaries.append(diary)
            }
            
            onComplete(diaries)
        }
    }
}
