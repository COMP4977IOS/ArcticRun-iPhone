//
//  Game.swift
//  ArcticRunTemplate
//
//  Created by Anthony on 2016-04-02.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

public class Game : NSObject, AVAudioPlayerDelegate {
    
    private let manager = GameConfigManager()
    private var curLevel = 0
    private var curSegment = 0
    private var levelData:NSArray = NSArray()
    private var audioPlayer = CustomAudioPlayer.sharedInstance
    private var viewController:UIViewController
    private var delayTimer:NSTimer?
    private var speechSynthesizer = AVSpeechSynthesizer()
    
    public init(viewController:UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    // Plays a certain level. It uses the corresponding plist file for configuration.
    // eg playLevel(1) would load Level1.plist
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
    
    public func pauseLevel() {
        speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Word)
        audioPlayer.pauseAudio()
        if (delayTimer != nil) {
            delayTimer?.invalidate()
            delayTimer = nil
        }
    }
    
    public func stopLevel() {
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        audioPlayer.stopAudio()
        if (delayTimer != nil) {
            delayTimer?.invalidate()
            delayTimer = nil
        }
    }
    
    public func startTimeStamp(time : NSTimeInterval){
        if speechSynthesizer.paused {
            speechSynthesizer.continueSpeaking()
        }
        // start audio at specific timestamp
        audioPlayer.startTime(time)
    }
    
    public func isPaused() -> Bool{
        return audioPlayer.isPaused
    }
    
    public func getTimeStamp() -> NSTimeInterval{
        return audioPlayer.getTimestamp()
    }
    
    
    // Internal function that is used to play individual segments of a level
    // This is called by playLevel()
    private func playSegment() {
        let segmentData = manager.getLevelSegment(curSegment)
        if (segmentData!["type"] as! String == "audio") {
            
            if UIApplication.sharedApplication().applicationState == .Active {
                print("AUDIO FOREGROUND")
            } else {
                print("AUDIO BACKGROUND")
            }
            
            let fileName:String = segmentData!["filename"] as! String
            audioPlayer.localDelegate = self
            audioPlayer.playAudio(fileName)

        } else {
            
            if UIApplication.sharedApplication().applicationState == .Active {
                print("PAUSE FOREGROUND")
            } else {
                print("PAUSE BACKGROUND")
            }
            let initialTimeInt = segmentData!["length"] as! Int
            let partyHealth = getMembersHealth()
            let calcTimeInt = generateTimeDelay(Float(initialTimeInt), partyHealth: partyHealth)
            let pauseTime = NSTimeInterval(calcTimeInt)
            
            print("-- Waiting for " + String(calcTimeInt) + " seconds before playing next level segment --")
            
            // temporary, to simulate time going by
            delayTimer = NSTimer.scheduledTimerWithTimeInterval(pauseTime, target: self, selector: "finish", userInfo: nil, repeats: false)
            
            // run text to speech if applicable
            let textSpeech:String? = segmentData!["speech"] as? String
            if (textSpeech != nil) {
                textToSpeech(textSpeech!)
            }
            
        }
    }
    
    public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        finish()
    }

    // Function used to create time delay between audio segments
    // Takes in an int - This int should come from a database query of all active party members health divided by total active party members. This number should range from 0-100.
    private func generateTimeDelay(baseDelay:Float, partyHealth:Int) -> Int {
        // Three minute delay between segments - Subject to change
        var additionalDelay:Float
        // Depending on the health of the party, increase the time delay between segments
        if(partyHealth < 25) {
            additionalDelay = baseDelay * 2.2
        } else if (partyHealth < 50) {
            additionalDelay = baseDelay * 1.7
        } else if (partyHealth < 75) {
            additionalDelay = baseDelay * 1.5
        } else {
            additionalDelay = baseDelay * 1.25
        }
        
        return  Int(additionalDelay)
    }
    
    // Query the database for all active members, add up their health, then divide by total active members and return the average
    private func getMembersHealth() -> Int {
        var totalActiveMembers = 1
        var totalHealth = 1
        Member.getAllMembers { (members: [Member]) -> Void in
            for var i = 0; i < members.count; i++ {
                if(members[i].getStatus() == "Active") {
                    totalHealth += members[i].getHealth()!
                    totalActiveMembers++
                }
            }
        }
        return totalHealth / totalActiveMembers
    }
    
    // Change the health of a party member
    // Pass in the party member's last name, the amount to change their health by, and the direction to change it
    public func changeMembersHealth(partyMemberLastName: String, healthChange: Int, healthMovement: String) {
        
        Member.getAllMembers { (members: [Member]) -> Void in
            for var i = 0; i < members.count; i++ {
                if (members[i].getLastName() == partyMemberLastName) {
                    var tempHealth = members[i].getHealth()
                    if(healthMovement == "Up") {
                        tempHealth = tempHealth! + healthChange
                        if(tempHealth > 100) {
                            tempHealth = 100
                        }
                        members[i].setHealth(tempHealth!)
                    } else if (healthMovement == "Down"){
                        tempHealth = tempHealth! - healthChange
                        if(tempHealth < 0) {
                            tempHealth = 0
                        }
                        members[i].setHealth(tempHealth!)
                    }
                }
            }
        }
    }
    
    // Text to speech. *Not tested*
    public func textToSpeech(input: String) {
        var myUtterance = AVSpeechUtterance(string: "")
        myUtterance = AVSpeechUtterance(string: input)
        myUtterance.rate = 0.3
        speechSynthesizer.speakUtterance(myUtterance)
    }
    
    // Called when the current level segment is finished
    @objc public func finish() {
        let levelCount = levelData.count - 1    // All segments minus the level information part in plist
        if (curSegment < levelCount) {
            curSegment += 1
            playSegment()
        } else {
            viewController.dismissViewControllerAnimated(true, completion: {});
        }
    }
    
    
}
