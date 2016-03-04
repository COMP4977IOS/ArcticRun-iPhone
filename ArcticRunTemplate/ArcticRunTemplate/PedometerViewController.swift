//
//  PedometerViewController.swift
//  ArcticRunTemplate
//
//

import UIKit
import CoreMotion
class PedometerViewController: UIViewController {
    
    let pedoMeter = CMPedometer()
    var timer = NSTimer()
    var rightNow:NSDate?
    var testNumber:Int = 25;
    var testSteps:Int = 0;
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var stepsTextForDay: UILabel!
    @IBOutlet weak var missionStateLabel: UILabel!
    
    @IBOutlet weak var numberOfStepsText: UILabel!
    @IBOutlet weak var outOfText: UILabel!
    
    @IBOutlet weak var distanceTravelledTodayText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outOfText.text = String(testNumber)
        // Do any additional setup after loading the view, typically from a nib.
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Call HealthKitHelper to get Steps and Distance for today
        //Need now to work on storing this data onto cloudkit
        HealthKitHelper().recentSteps() { steps, error in
           self.stepsTextForDay.text = String(steps)
        }
        
        HealthKitHelper().recentDistance() { distance, error in
            self.distanceTravelledTodayText.text = String(distance)
        }
        
    }
    
    @IBAction func start(sender : AnyObject) {
        rightNow = NSDate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.75, target: self, selector: Selector("updateCounting"), userInfo: nil, repeats: true)
    }
    
    //Counting number of steps taken 
    //Test steps is just incrementing change it to being the number of steps from pedometer
    func updateCounting() {
        //testSteps++
        //self.numberOfStepsText.text = String(testSteps)
        if (testSteps >= self.testNumber) {
            self.completeMission()
        }
        
        if(CMPedometer.isStepCountingAvailable()){
            self.pedoMeter.queryPedometerDataFromDate(rightNow!, toDate: NSDate()) { (data : CMPedometerData?, error) -> Void in
                print(data)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error == nil){
                        if (data!.numberOfSteps as Int >= self.testNumber) {
                            self.completeMission()
                        }
                        self.numberOfStepsText.text = "\(data!.numberOfSteps)"
                    }
                })
                
            }
        }
    }
    
    //When the mission is complete do something, here you can add that it finished in database
    func completeMission() {
        missionStateLabel.text = "Mission Complete!"
        timer.invalidate()
    }
    
    //Halts run and turns of timer that runs pedometer
    @IBAction func stopRun() {
        timer.invalidate()
    }

    
    
    
    
}