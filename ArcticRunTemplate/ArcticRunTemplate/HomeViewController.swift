//
//  HomeViewController.swift
//  ArcticRunTemplate
//
//  Created by Matt Wiseman on 2016-02-21.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var fitnessButton: UIButton!
    @IBOutlet weak var crewButton: UIButton!
//    @IBOutlet weak var seasonPicker: UIPickerView!
//    @IBOutlet weak var synopsisText: UITextView!
//    @IBOutlet weak var PausePlay: UIButton!
//    
//    @IBOutlet weak var timeLabel: UILabel!
//    var timer = NSTimer()
//    var startTime = NSTimeInterval()
//    
//    var seasonArray:[String]!
//    var missionArray:[String]!
//    var season:String!
//    var mission:String!
//    
   @IBOutlet weak var menuButton: UIBarButtonItem!
//    
//    var ButtonAudioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ButtonAudio", ofType: "wav")!)
//    var BackgroundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("BackgroundAudio", ofType: "mp3")!)
//    var ButtonAudioPlayer = AVAudioPlayer()
//    var BackgroundAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBG()
        startButton.layer.cornerRadius = 5
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.blackColor().CGColor
        
        fitnessButton.layer.cornerRadius = 5
        fitnessButton.layer.borderWidth = 1
        fitnessButton.layer.borderColor = UIColor.blackColor().CGColor
        
        crewButton.layer.cornerRadius = 5
        crewButton.layer.borderWidth = 1
        crewButton.layer.borderColor = UIColor.blackColor().CGColor
        // Do any additional setup after loading the view, typically from a nib.
//        
//        seasonArray = ["season 1","season 2","season 3","season 4"]
//        missionArray = ["mission 1","mission 2","mission 3","mission 4","mission 5"]
//        
//        season = seasonArray[0]
//        mission = missionArray[0]
//        synopsisText.text = mission + "\t" + season
//        do{
//            try  ButtonAudioPlayer = AVAudioPlayer(contentsOfURL: ButtonAudioURL)
//        } catch {}
//        
//        do{
//            try  BackgroundAudioPlayer = AVAudioPlayer(contentsOfURL: BackgroundURL)
//        } catch{}
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
 
    func loadBG() {
        
        // Gradient Background color
        let background = CAGradientLayer().blueblendColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView)->Int{
        return 2
    }
//    
//    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component:Int)->Int{
//        if component == 0 {
//            return seasonArray.count
//        }
//            
//        else {
//            return missionArray.count
//        }
//        
//    }
//    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        
//        if component == 0{
//            return seasonArray[row]
//        }else{
//            return missionArray[row]
//        }
//    }
//    
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//        if component == 0{
//            season = seasonArray[row]
//        }
//        else{
//            mission = missionArray[row]
//        }
//        synopsisText.text = mission + "\t" + season
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    @IBAction func PlayAudio1(sender: AnyObject) {
//        ButtonAudioPlayer.play()
//    }
//    
//    func updateTime(){
//        let currentTime = NSDate.timeIntervalSinceReferenceDate()
//        
//        //Find the difference between current time and start time.
//        
//        var elapsedTime: NSTimeInterval = currentTime - startTime
//        
//        //calculate the minutes in elapsed time.
//        
//        let minutes = UInt8(elapsedTime / 60.0)
//        
//        elapsedTime -= (NSTimeInterval(minutes) * 60)
//        
//        //calculate the seconds in elapsed time.
//        
//        let seconds = UInt8(elapsedTime)
//        
//        elapsedTime -= NSTimeInterval(seconds)
//        
//        //find out the fraction of milliseconds to be displayed.
//        
//        let fraction = UInt8(elapsedTime * 100)
//        
//        //add the leading zero for minutes, seconds and millseconds and store them as string constants
//        
//        let strMinutes = String(format: "%02d", minutes)
//        let strSeconds = String(format: "%02d", seconds)
//        let strFraction = String(format: "%02d", fraction)
//        
//        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
//        
//        timeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
//    }
//    
//    @IBAction func Stop(sender: AnyObject) {
//        BackgroundAudioPlayer.stop()
//        timer.invalidate()
//        timer = NSTimer()
//        
//        timeLabel.text = "00:00:00"
//        
//        BackgroundAudioPlayer.currentTime = 0
//        PausePlay.setTitle("Play", forState: UIControlState.Normal)
//    }
//    
//    @IBAction func Pause(sender: AnyObject) {
//        
//        // Start to play background music
//        if(BackgroundAudioPlayer.playing == false){
//            BackgroundAudioPlayer.play()
//            PausePlay.setTitle("Pause", forState: UIControlState.Normal)
//            
//            if !timer.valid {
//                let aSelector : Selector = "updateTime"
//                timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector,     userInfo: nil, repeats: true)
//                startTime = NSDate.timeIntervalSinceReferenceDate()
//            }
//        }else{
//            BackgroundAudioPlayer.stop()
//            timer.invalidate()
//            PausePlay.setTitle("Play", forState: UIControlState.Normal)
//        }
//    }
//    
//    @IBAction func Restart(sender: AnyObject) {
//        BackgroundAudioPlayer.stop()
//        timer.invalidate()
//        timer = NSTimer()
//        timeLabel.text = "00:00:00"
//        BackgroundAudioPlayer.currentTime = 0
//        BackgroundAudioPlayer.play()
//    }
}


    /*
    // MARK: Navigation -

    // In a storyboard-based application,you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController
    // Pass the selected object to the new view controller
    }
    */



