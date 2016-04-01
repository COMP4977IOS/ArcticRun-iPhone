//
//  PlayScreenViewController.swift
//  ArcticRunTemplate
//
//  Created by Matt Wiseman on 2016-03-30.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import Foundation
import UIKit

class PlayScreenViewController : UIViewController {
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    var passData : String!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var startTimer: Bool!
    var strMinutes : String!
    var strSeconds : String!
    
    let imagePause = UIImage(named:"Pause") as UIImage?
    let imagePlay = UIImage(named: "Play") as UIImage?
    let imageStop = UIImage(named: "Stop") as UIImage?
    
    var startTime = NSTimeInterval()
    var referTime = NSTimeInterval()
    var timer = NSTimer()
    
    
    var running = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBG()
        
        // TODO: Pass data from MissionViewController to label, not working like it is from GameMap
        //titleLabel.text = passData
        
        titleLabel.text = "Passed Label Data"
        
        
    }
    
    
    
    @IBAction func pause(sender: AnyObject) {
        
        timer.invalidate()
        running = false
        
    }
    @IBAction func playAndPause(sender: AnyObject) {
        
        let aSelector : Selector = "updateCounter"
        
        if !running {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            running = true
        }else {
           
        }
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
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        timerLabel.text = "\(strMinutes):\(strSeconds)"
        
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        timer.invalidate()
        timerLabel.text = "\(00):\(00)"
        running = false
    }
    
}
