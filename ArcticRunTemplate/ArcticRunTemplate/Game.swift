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
    private var audioPlayer = CustomAudioPlayer.sharedInstance
    
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
    
    public func pauseLevel() {
        audioPlayer.pauseAudio()
    }
    
    public func stopLevel() {
        audioPlayer.stopAudio()
    }
    
    public func startTimeStamp(time : NSTimeInterval){
        // start audio at specific timestamp
        audioPlayer.startTime(time)
    }
    
    public func isPaused() -> Bool{
        return audioPlayer.isPaused
    }
    
    public func getTimeStamp() -> NSTimeInterval{
        return audioPlayer.getTimestamp()
    }
    
    
    private func playSegment() {
        let segmentData = manager.getLevelSegment(curSegment)
        if (segmentData!["type"] as! String == "audio") {
            
            if UIApplication.sharedApplication().applicationState == .Active {
                print("AUDIO FOREGROUND")
            } else {
                print("AUDIO BACKGROUND")
            }
            
            let fileName:String = segmentData!["filename"] as! String
            audioPlayer.playAudio(fileName)

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
    
    @objc public func finish() {
        if (curSegment < levelData.count) {
            curSegment += 1
            playSegment()
        }
    }
    
}
