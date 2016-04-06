//
//  PlayScreenViewController.swift
//  ArcticRunTemplate
//
//  Created by Matt Wiseman on 2016-03-30.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class PlayScreenViewController : UIViewController {
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    var passData : String!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var startTimer: Bool!
    var strMinutes : String!
    var strSeconds : String!
    
    let imagePause = UIImage(named:"Pause") as UIImage?
    let imagePlay = UIImage(named: "Play") as UIImage?
    let imageStop = UIImage(named: "Stop") as UIImage?
    let dataProcessingQueue = NSOperationQueue()
    let pedometer = CMPedometer()
    let lengthFormatter = NSLengthFormatter()
    
    var startTime = NSTimeInterval()
    var referTime = NSTimeInterval()
    var timer = NSTimer()
    
    var running = false
    var started:Bool = false
    
    var game:Game!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBG()
        
        // TODO: Pass data from MissionViewController to label, not working like it is from GameMap
        //titleLabel.text = passData
        
        titleLabel.text = "Passed Label Data"
        
        playPause()
        
    }
    
    private func playPause() {
        let aSelector : Selector = "updateCounter"
        /*
        if(timeStamp != ""){
            print(timeStamp)
            
        }
        */
        
        if(!CustomAudioPlayer.sharedInstance.isPaused){
            print("Starting a new game")
            game = Game()
        } else {
            print("\n\nusing previous game")
            let time = game.getTimeStamp()
            print(time)
            game.startTimeStamp(time)
        }
        
        if !running {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            running = true
            if (started == false) {
                pedometer.startPedometerUpdatesFromDate(NSDate()) {
                    (data, error) in
                    if error != nil {
                        print("There was an error obtaining pedometer data: \(error)")
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.stepsLabel.text = "\(data!.numberOfSteps)"
                            self.distanceLabel.text = "\(self.lengthFormatter.stringFromMeters(data!.distance as! Double))"
                            self.started = true
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func pause(sender: AnyObject) {
        /*
        timer.invalidate()
        running = false
        if(started) {
            pedometer.stopPedometerUpdates()
            self.started = false
        }
        game.pauseLevel()
        getTimeStamp()
        */
        running = false
        if(started) {
            pedometer.stopPedometerUpdates()
            self.started = false
        }
        print("trying to pause")
        game.pauseLevel()
        
    }
    
    @IBAction func playAndPause(sender: AnyObject) {
        playPause()
    }
    
    @IBAction func stopGame(sender: AnyObject) {
        let alert = UIAlertController(title: "The Ship", message: "Are you sure you want to quit?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.Default, handler: { dismiss }()))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadBG() {
        // Gradient Background color
        let background = CAGradientLayer().blueblendColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
    
    func updateCounter() {
        /*
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        timerLabel.text = "\(strMinutes):\(strSeconds)"
         */
        let timeStamp = CustomAudioPlayer.sharedInstance.getTimestamp()
        
        /*
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        */
        
        
        let interval = Int(timeStamp)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        timerLabel.text = "\(strMinutes):\(strSeconds)"
        
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        timer.invalidate()
        timerLabel.text = "\(00):\(00)"
        running = false
        game.stopLevel()
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    
    func getTimeStamp() -> String{
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        timeStamp = strMinutes + ":" + strSeconds
        
        return timeStamp
    }
     */
    
}
