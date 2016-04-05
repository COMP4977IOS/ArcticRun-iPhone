//
//  Game.swift
//  ArcticRunTemplate
//
//  Created by Anthony on 2016-04-02.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import Foundation

public class Game {
    
    private let manager = GameConfigManager()
    private var curLevel = 0
    private var curSegment = 0
    private var levelData:NSDictionary = NSDictionary()
    
    init() {
        playLevel(1)
    }
    
    public func playLevel(level:Int) {
        levelData = manager.loadLevel(level)!
        if levelData == .None {
            print("Unable to get Plist")
            return
        } else {
            curLevel = level
            curSegment = 1
            playSegment()
        }
    }
    
    private func playSegment() {
        let segmentData = manager.getLevelSegment(curSegment)
        if (segmentData!["type"] as! String == "audio") {
            
            if UIApplication.sharedApplication().applicationState == .Active {
                print("AUDIO FOREGROUND")
            } else {
                print("AUDIO BACKGROUND")
            }
            
            // temporary, to simulate time going by
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "finish", userInfo: nil, repeats: false)
        } else {
            let pauseTimeInt = segmentData!["length"] as! Int
            let pauseTime = NSTimeInterval(pauseTimeInt)
            
            if UIApplication.sharedApplication().applicationState == .Active {
                print("PAUSE FOREGROUND")
            } else {
                print("PAUSE BACKGROUND")
            }
            
            // temporary, to simulate time going by
            NSTimer.scheduledTimerWithTimeInterval(pauseTime, target: self, selector: "finish", userInfo: nil, repeats: false)
        }
    }
    
    // Function used to create time delay between audio segments
    // Takes in an int - This int should come from a database query of all active party members health divided by total active party members. This number should range from 0-100.
    private func generateTimeDelay(partyHealth:Int) -> Int {
        // Three minute delay between segments - Subject to change
        var baseDelay = 180.0
        // Depending on the health of the party, increase the time delay between segments
        if(partyHealth < 25) {
            baseDelay = baseDelay * 2.2
        } else if (partyHealth < 50) {
            baseDelay = baseDelay * 1.7
        } else if (partyHealth < 75) {
            baseDelay = baseDelay * 1.5
        } else {
            baseDelay = baseDelay * 1.25
        }
        
        return  Int(baseDelay)
    }
    
    // Query the database for all active members, add up their health, then divide by total active members and return the average
    private func getMembersHealth() -> Int {
        var totalActiveMembers = 0
        var totalHealth = 0
        Member.getAllMembers { (members: [Member]) -> Void in
            for totalActiveMembers = 0; totalActiveMembers < members.count; totalActiveMembers++ {
                if(members[totalActiveMembers].getStatus() == "Active") {
                    totalHealth += members[totalActiveMembers].getHealth()!
                }
            }
        }
        return totalHealth / totalActiveMembers
    }
        
        
    @objc public func finish() {
        if (curSegment < levelData.count) {
            curSegment += 1
            playSegment()
        }
    }
    
}
