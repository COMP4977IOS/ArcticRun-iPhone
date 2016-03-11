//
//  HomeViewController.swift
//  ArcticRunTemplate
//
//  Created by Matt Wiseman on 2016-02-21.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var seasonPicker: UIPickerView!
    @IBOutlet weak var synopsisText: UITextView!
    
    var seasonArray:[String]!
    var missionArray:[String]!
    var season:String!
    var mission:String!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var timeLabel: UILabel!
    var timer = NSTimer()
    @IBOutlet weak var startButton: UIButton!
    var startTime = NSTimeInterval()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        seasonArray = ["season 1","season 2","season 3","season 4"]
        missionArray = ["mission 1","mission 2","mission 3","mission 4","mission 5"]
        
        season = seasonArray[0]
        mission = missionArray[0]
        synopsisText.text = mission + "\t" + season
        
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
 
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView)->Int{
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component:Int)->Int{
        if component == 0 {
            return seasonArray.count
        }
            
        else {
            return missionArray.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0{
            return seasonArray[row]
        }else{
            return missionArray[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0{
            season = seasonArray[row]
        }
        else{
            mission = missionArray[row]
        }
        synopsisText.text = mission + "\t" + season
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startFunction(sender: AnyObject) {
        if !timer.valid {
            let aSelector : Selector = "updateTime"
            if(startButton.currentTitle == "Start" || startButton.currentTitle == "Resume"){
                timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector,     userInfo: nil, repeats: true)
                startTime = NSDate.timeIntervalSinceReferenceDate()
                startButton.setTitle("Pause",forState: .Normal)
            }
        }
        
    }
    
    @IBAction func stop(sender: AnyObject) {
        timer.invalidate()
        timer = NSTimer()
        startButton.setTitle("Start",forState: .Normal)
    }
    
    func updateTime(){
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        timeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
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
