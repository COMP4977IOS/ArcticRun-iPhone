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
    var localDelegate:AVAudioPlayerDelegate?
    
    private override init() {
        super.init()
        
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
        
        localDelegate = self
    }

    func playAudio(fileName : String){
        let fileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: "mp3")!)
        
        if (isPlaying) {
            audioPlayer.stop()
        }
        if (isPaused) {
            audioPlayer.play()
            isPaused = false
        }
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: fileURL)
            audioPlayer.delegate = localDelegate
            audioPlayer.play()
            isPlaying = true
        } catch{
            print("ERROR")
        }
    }
    
    func pauseAudio() {
        if (!isPaused) {
            audioPlayer.pause()
            isPaused = true
        }
    }
    
    func stopAudio() {
        if (isPlaying) {
            audioPlayer.stop()
        }
    }
    
    public func finish() {
        isPlaying = false
        isPaused = false
    }
    
    public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        finish()
    }
}