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
    var calories: Int = 0
    var distance: Double = 0
    var missionPercentage:Int = 0
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var circularProgressBar: KDCircularProgress!
    
    var maxTime:Double = 3.22
    
    var lastTimeFrame:NSTimeInterval = 0
    var currentOverallTime:NSTimeInterval = 0
    var currentAudioTime:NSTimeInterval = 0
    var maxLevelTime:Int = 0
    
    @IBOutlet weak var percentageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBG()
        circularProgressBar.angle = 0
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase

        titleLabel.text = passData
        print("View Loading")
        
        lastTimeFrame = NSDate.timeIntervalSinceReferenceDate()
        game = Game()
        maxLevelTime = game.getLevelLength(chapterNum)
        print("MAX LEVEL: " + String(maxLevelTime))
        
        playPause()
        
    }
    
    private func playPause() {
        //sets time of each segment
        
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
            game = Game()
            game.playLevel(chapterNum)
        } else if(game == nil){
            game = Game()
            game.playLevel(chapterNum)
        } else {
            print("\n\nusing previous game")
            let time = game.getTimeStamp()
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
        let alert = UIAlertController(title: "\(passData)", message: "Are you sure you want to quit?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { dismiss }()))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadBG() {
        // Gradient Background color
        let background = CAGradientLayer().blueblendColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
    
    func updateCounter() {
        let delta =  NSDate.timeIntervalSinceReferenceDate() - lastTimeFrame
        currentOverallTime += delta
        if (running && game.isAudioSegment) {
            currentAudioTime += delta
        }
        lastTimeFrame = NSDate.timeIntervalSinceReferenceDate()
        
        
        let interval = Int(currentAudioTime)
        missionProgress = Double(interval) / 60
        missionPercentage = Int(Double((missionProgress / Double(maxLevelTime / 60)) * 100.00))
        percentageLabel.text = String(missionPercentage) + "%"
        
        
        let overallInterval = Int(currentOverallTime)
        let overallSeconds = overallInterval % 60
        let overallMinutes = (overallInterval / 60) % 60
        let strMinutes = String(format: "%02d", overallMinutes)
        let strSeconds = String(format: "%02d", overallSeconds)
        timerLabel.text = "\(strMinutes):\(strSeconds)"
        
        if (interval != maxLevelTime) {
            let maxProgress:Double = Double(maxLevelTime) / 60
            let newAngleValue = 360 * (missionProgress/maxProgress)
            circularProgressBar.animateToAngle(newAngleValue, duration: 0.05, completion: nil)
        }
        if (game.isFinished) {
            
            if(started) {
                pedometer.stopPedometerUpdates()
                self.started = false
            }
            timer.invalidate()
            timerLabel.text = "\(00):\(00)"
            running = false
            game.stopLevel()
            
            saveWorkout(steps, distance: distance)
            calories = steps / 20
            let alert = UIAlertController(title: "Mission Complete!", message: "You have Received \(steps) Coins and \(calories) Gems!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { dismiss }()))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        saveWorkout(steps, distance: distance)
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
                self.currentCaloriesBurned = crews[i].getCaloriePoints()!
            }
            
            let resultSteps = self.currentSteps + self.steps
            let resultCalories = self.currentCaloriesBurned + self.steps
            
            for var i = 0; i < crews.count; i++ {
                crews[i].setStepPoints(resultSteps)
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
