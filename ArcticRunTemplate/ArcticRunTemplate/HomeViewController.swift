//
//  HomeViewController.swift
//  ArcticRunTemplate
//
//  Created by Matt Wiseman on 2016-02-21.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, AVAudioPlayerDelegate {
    
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
    
    
    var audioFiles : [String] = ["chap1_segment1","chap1_segment2","chap1_segment3","chap1_segment4",
                                 "chap2_segment1","chap2_segment2","chap3_segment3"]
    var audioCounter : Int = 0
    
    var ButtonAudioPlayer = AVAudioPlayer()
    var introPlayed : Bool = false
    var prefacePlayed : Bool = false
    var current:Int = 0

    @IBOutlet weak var goldCurrency: UILabel!
    
    @IBOutlet weak var gemCurrency: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isICloudContainerAvailable() == true){
            print("loggedin")
        }else{
            print("not logged in")
        }
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
        
        Crew.getAllCrews { (crews: [Crew]) -> Void in
            for var i = 0; i < crews.count; i++ {
                self.current = crews[i].getCaloriePoints()!
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.gemCurrency.text = String(self.current)
            }
        }
        
        Crew.getAllCrews { (crews: [Crew]) -> Void in
            for var i = 0; i < crews.count; i++ {
                self.current = crews[i].getStepPoints()!
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.goldCurrency.text = String(self.current)
            }

        }
        // TODO: Remove, this is just for testing purposes
        
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
        
        //let g :Game = Game(viewController: self)
        //var test = String(g.getMembersHealth())
        //print(test + " member health")
//        g.changeMembersHealth("Joyce", healthChange: 10, healthMovement: "Down")
        
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
    
    
    
    @IBAction func startRun(sender: AnyObject) {
        print("\n\nStarting Run")
        whichVideoPlay();
    }
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("AUDIO FINISHED")
        whichVideoPlay()
    }
    
    func whichVideoPlay(){
        if(!prefacePlayed){
            prefacePlayed = true
            playSpecificVideo("preface")
        } else if(!introPlayed){
            introPlayed = true
            playSpecificVideo("introduction")
        } else {
            // Chapter Files
            playSpecificVideo(audioFiles[audioCounter])
            audioCounter++
        }
    }
    
    func playSpecificVideo(fileName : String){
        do {
            print(fileName)
            let fileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: "mp3")!)
            try ButtonAudioPlayer = AVAudioPlayer(contentsOfURL: fileURL)
            if(!prefacePlayed || !introPlayed){
                ButtonAudioPlayer.delegate = self
            }
            ButtonAudioPlayer.play()
            print(fileURL)
        } catch{
            print("ERROR")
        }
    }
    
    func isICloudContainerAvailable()->Bool {
        if let currentToken = NSFileManager.defaultManager().ubiquityIdentityToken {
            return true
        }
        else {
            return false
        }
    }

}


    /*
    // MARK: Navigation -

    // In a storyboard-based application,you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController
    // Pass the selected object to the new view controller
    }
    */



