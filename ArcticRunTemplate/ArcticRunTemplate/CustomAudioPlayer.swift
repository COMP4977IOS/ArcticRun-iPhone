//
//  CustomAudioPlayer.swift
//  ArcticRunTemplate
//
//  Created by Jan Ycasas on 2016-04-04.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import AVFoundation

class CustomAudioPlayer : AVAudioPlayer, AVAudioPlayerDelegate{
    
    override init(contentsOfURL url: NSURL) throws {
        do{
            try super.init(contentsOfURL: url)
        } catch{
            print("ERROR")
        }
    }
    
    override init(contentsOfURL url: NSURL, fileTypeHint utiString: String?) throws {
        do{
            try super.init(contentsOfURL: url, fileTypeHint: utiString)
        } catch{
            print("ERROR")
        }
    }
    /*
    func startAudio(fileName : String){
        let fileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: "mp3")!)
        do{
            try AudioPlayer = AVAudioPlayer(contentsOfURL: fileURL)
            print(fileURL)
            AudioPlayer.play()
        } catch{
            print("ERROR")
        }
    }
    */
    override func play() -> Bool {
        print("TRYING TO PLAY CUSTOM")
        print(url)
        super.play()
        return true
    }
    

    
    
}