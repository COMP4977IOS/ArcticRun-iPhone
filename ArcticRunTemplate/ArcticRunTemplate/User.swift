//
//  User.swift
//  ArcticRun-iPad
//
//  Created by Anthony on 2016-03-04.
//  Copyright © 2016 COMP 4977. All rights reserved.
//

import Foundation
import CloudKit

public class User {
    let container:CKContainer = CKContainer.defaultContainer()
    let privateDB:CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
    
    var firstName:String?
    var lastName:String?
    var record:CKRecord?
    var isReady:Bool = false    //TODO: is this even needed?
    
    //TODO: Add a closure
    init() {
        self.container.fetchUserRecordIDWithCompletionHandler { (recordID:CKRecordID?, error: NSError?) -> Void in
            if error == nil && recordID != nil {
                
                //set first and last name
                self.container.discoverUserInfoWithUserRecordID(recordID!, completionHandler: { (userInfo: CKDiscoveredUserInfo?, error: NSError?) -> Void in
                    if error == nil && userInfo != nil {
                        self.firstName = userInfo?.displayContact?.givenName
                        self.lastName = userInfo?.displayContact?.familyName
                    }
                })
                
                //set record
                self.privateDB.fetchRecordWithID(recordID!, completionHandler: { (record: CKRecord?, error: NSError?) -> Void in
                    if error == nil && record != nil {
                        self.record = record
                        self.isReady = true
                    }
                })
            }
        }
    }
    
    func getFirstName() -> String? {
        return self.firstName
    }
    
    func getLastName() -> String? {
        return self.lastName!
    }
    
    func getRecordID() -> String? {
        return (self.record?.recordID.recordName)!
    }
    
    func getCKRecordID() -> CKRecordID? {
        return (self.record?.recordID)!
    }
    
    func getRecord() -> CKRecord? {
        return self.record!
    }
}
