//
//  Crew.swift
//  ArcticRun-iPad
//
//  Created by Anthony on 2016-03-03.
//  Copyright © 2016 COMP 4977. All rights reserved.
//

import Foundation
import CloudKit

public class Crew {
    static let publicDB:CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    
    var record:CKRecord?    //a record of this instance
    
    init(crewRecord: CKRecord) {
        self.record = crewRecord
    }
    
    init(caloriesPoints: Int, challengeID: Int, gameLevel: Int, members: [CKReference], name: String, resources:[CKReference], user: CKReference){
        self.record = CKRecord(recordType: "Crew")
        
        self.record?.setObject(caloriesPoints, forKey: "caloriePoints")
        self.record?.setObject(challengeID, forKey: "challengeID")
        self.record?.setObject(gameLevel, forKey: "gameLevel")
        self.record?.setObject(members, forKey: "member")
        self.record?.setObject(name, forKey: "name")
        self.record?.setObject(resources, forKey: "resource")
        self.record?.setObject(user, forKey: "user")
    }
    
    func getCaloriePoints() -> Int? {
        return self.record?.objectForKey("caloriePoints") as? Int
    }
    
    func setCaloriePoints(caloriesPoints:Int) -> Void {
        self.record?.setObject(caloriesPoints, forKey: "caloriePoints")
    }
    
    func getChallengeID() -> Int? {
        return self.record?.objectForKey("challengeID") as? Int
    }
    
    func setChallengeID(challengeID: Int) -> Void {
        self.record?.setObject(challengeID, forKey: "challengeID")
    }
    
    func getGameLevel() -> Int? {
        return self.record?.objectForKey("gameLevel") as? Int
    }
    
    func setGameLevel(gameLevel: Int) -> Void {
        self.record?.setObject(gameLevel, forKey: "gameLevel")
    }
    
    //TODO func getMembers() -> [Member]
    //TODO func setMembers(members:[Member]) -> Void
    //TODO func addMember(member:Member) -> Void
    //TODO func addMembers(members:[Member]) -> Void
    //TODO static func addMember(crew:Crew, member:Member) -> Void
    
    func getMemberReferences() -> [CKReference]? {
        return self.record?.objectForKey("member") as? [CKReference]
    }
    
    func setMemberReferences(members: [CKReference]) -> Void {
        self.record?.setObject(members, forKey: "member")
    }
    
    func getName() -> String? {
        return self.record?.objectForKey("name") as? String
    }
    
    func setName(name: String) -> Void {
        self.record?.setObject(name, forKey: "name")
    }
    
    func getResourceReferences() -> [CKReference]? {
        return self.record?.objectForKey("resource") as? [CKReference]
    }
    
    func setResourceReferences(resources: [CKReference]) -> Void {
        self.record?.setObject(resources, forKey: "resource")
    }
    
    func getUser() -> CKReference? {
        return record?.objectForKey("user") as? CKReference
    }
    
    func setUser(user: CKReference) -> Void {
        self.record?.setObject(user, forKey: "user")
    }
    
    func save() -> Void{
        Crew.publicDB.saveRecord(self.record!) { (record: CKRecord?, error:NSError?) -> Void in
            if error == nil {
                print("record saved")
            }
        }
    }
    
    static func getCrew(userRecord: CKRecord, onComplete:([Crew]) -> Void) -> Void{
        let predicate:NSPredicate = NSPredicate(format: "user == %@", userRecord)   //get all crews under the referenced user
        let query:CKQuery = CKQuery(recordType: "Crew", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]   //sort by desc
        
        //perform query
        publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if(error != nil || records == nil){
                return  //nothing
            }
            
            var crews:[Crew] = []
            for var i = 0; i < records?.count; i++ {
                let crew:Crew = Crew(crewRecord: records![i])
                crews.append(crew)
            }
            
            onComplete(crews)
        }
    }

    static func getAllCrews(onComplete:([Crew]) -> Void) -> Void{
        let predicate:NSPredicate = NSPredicate(value: true)
        let query:CKQuery = CKQuery(recordType: "Crew", predicate: predicate)
        
        Crew.publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error:NSError?) -> Void in
            if error != nil || records == nil {
                return //found errors
            }
            
            var crews:[Crew] = []
            for var i = 0; i < records?.count; i++ {
                let crew:Crew = Crew(crewRecord: records![i])
                crews.append(crew)
            }
            
            onComplete(crews)
        }
    }
}
