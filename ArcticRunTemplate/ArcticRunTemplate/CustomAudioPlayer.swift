//
//  CustomAudioPlayer.swift
//  ArcticRunTemplate
//
//  Created by Jan Ycasas on 2016-04-04.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import AVFoundation

public class CustomAudioPlayer : NSObject, AVAudioPlayerDelegate {
    
    static let sharedInstance = CustomAudioPlayer()
    
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    var isPlaying:Bool = false
    var isPaused:Bool = false
    
    private override init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func playAudio(fileName : String){
        let fileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: "mp3")!)
        
        if (isPlaying) {
            audioPlayer.stop()
        }
        
        if (isPaused) {
            audioPlayer.play()
            isPaused = false
            isPlaying = true
        }
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: fileURL)
            
            audioPlayer.play()
            isPlaying = true
            isPaused = false
        } catch{
            print("ERROR")
        }
    }
    
    func pauseAudio() {
        print("CUSTOM AUDIO PLAYER PAUSE")
        
        print (isPaused)
        print(isPlaying)
        
        if (!isPaused) {
            audioPlayer.pause()
            isPaused = true
            isPlaying = false
            print("pausing audio")
        }
    }
    
    func stopAudio() {
        if (isPlaying) {
            isPaused = false
            isPlaying = false
            audioPlayer.stop()
        }
    }
    
    func getTimestamp() -> NSTimeInterval {
        return audioPlayer.currentTime
    }
    
    func startTime(time : NSTimeInterval){
        audioPlayer.prepareToPlay()
        //audioPlayer.playAtTime(time)
        
        if (isPlaying) {
            audioPlayer.stop()
        }
        
        if (isPaused) {
            audioPlayer.play()
            isPaused = false
            isPlaying = true
        }
        
        audioPlayer.play()
        isPlaying = true
        isPaused = false
    }
    
    public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        isPaused = false
        print("FINISHED")
    }
}