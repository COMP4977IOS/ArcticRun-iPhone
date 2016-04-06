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
import CloudKit

class PlayScreenViewController : UIViewController {
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    var passData : String!
    var chapterNum : Int!
    
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
    var startDate:NSDate?
    var setTime = false
    
    var missionProgress:Double = 0
    var currentSteps = 0
    var currentCaloriesBurned = 0
    var steps: Int = 0
    var distance: Double = 0
    var missionPercentage:Double = 0
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var circularProgressBar: KDCircularProgress!
    
    var maxTime:Double = 1.0
    
    @IBOutlet weak var percentageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBG()
        circularProgressBar.angle = 0
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase
        // TODO: Pass data from MissionViewController to label, not working like it is from GameMap
        titleLabel.text = passData
        
        //titleLabel.text = "Passed Label Data"
        
        print("View Loading")
        playPause()
        
    }
    
    private func playPause() {
        if (!setTime) {
            startDate = NSDate()
            setTime = true
        }
        
        playBtn.backgroundColor = UIColor.redColor()
        pauseButton.backgroundColor = UIColor.clearColor()
        
        let aSelector : Selector = "updateCounter"
        /*
        if(timeStamp != ""){
            print(timeStamp)
            
        }
        */
        
        if(!CustomAudioPlayer.sharedInstance.isPaused){
            print("Starting a new game")
            game = Game(viewController: self)
            game.playLevel(chapterNum)
        } else if(game == nil){
            game = Game(viewController: self)
            game.playLevel(chapterNum)
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
                            self.steps = data!.numberOfSteps as Int
                            self.distance = data!.distance as! Double
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
        playBtn.backgroundColor = UIColor.clearColor()
        pauseButton.backgroundColor = UIColor.redColor()
        running = false
        if(started) {
            pedometer.stopPedometerUpdates()
            self.started = false
        }
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
        missionProgress = Double(interval) / 60
        missionPercentage = missionProgress * 100.00
        percentageLabel.text = String(round(missionPercentage)) + "%"
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        timerLabel.text = "\(strMinutes):\(strSeconds)"
        if (missionProgress != maxTime) {
            let newAngleValue = 360 * (missionProgress/maxTime)
            //print(newAngleValue)
            circularProgressBar.animateToAngle(newAngleValue, duration: 0.1, completion: nil)
        } else if (missionProgress >= maxTime) {
            
            if(started) {
                pedometer.stopPedometerUpdates()
                self.started = false
            }
            timer.invalidate()
            timerLabel.text = "\(00):\(00)"
            running = false
            game.stopLevel()
            saveWorkout(steps, distance: distance)
            var calories = steps / 20
            let alert = UIAlertController(title: "Mission Complete!", message: "You have Received \(steps) Coins and \(calories) Gems!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { dismiss }()))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        if(started) {
            pedometer.stopPedometerUpdates()
            self.started = false
        }
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
    
    func saveWorkout(steps: Int, distance: Double) {
        
        Crew.getAllCrews { (crews: [Crew]) -> Void in
            for var i = 0; i < crews.count; i++ {
                self.currentSteps = crews[i].getStepPoints()!
            }
        }
        let resultSteps = currentSteps + steps
        
        Crew.getAllCrews { (crews: [Crew]) -> Void in
            for var i = 0; i < crews.count; i++ {
                crews[i].setStepPoints(resultSteps)
                crews[i].save()
            }
        }
        
        Crew.getAllCrews { (crews: [Crew]) -> Void in
            for var i = 0; i < crews.count; i++ {
                self.currentCaloriesBurned = crews[i].getCaloriePoints()!
            }
        }
        let resultCalories = currentCaloriesBurned + steps
        
        Crew.getAllCrews { (crews: [Crew]) -> Void in
            for var i = 0; i < crews.count; i++ {
                crews[i].setCaloriePoints(resultCalories)
                crews[i].save()
            }
        }
        
        let caloriesBurned:Int = steps / 20
        
        let wk = Workout.init(caloriesBurned: caloriesBurned, distance: distance, endDate: NSDate(), fastestSpeed: 0, startDate: startDate!, steps: steps)
        
        wk.save()

    }
    
    func saveProgress() {
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase
        
        let record = CKRecord(recordType: "Mission")
        
        record.setValue(missionProgress, forKey: "progress")
        record.setValue(passData, forKey: "title")
        publicData.saveRecord(record, completionHandler: { record, error in
            if error != nil {
                print(error)
            }
        })
    }
    
    func getProgress() {
        
    }
    
}
