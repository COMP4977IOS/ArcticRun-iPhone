//
//  PedometerViewController.swift
//  ArcticRunTemplate
//
//

import UIKit
import CoreMotion
class PedometerViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var floorsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var activityImageView: UIImageView!
    
    let dataProcessingQueue = NSOperationQueue()
    let pedometer = CMPedometer()
    let altimeter = CMAltimeter()
    let activityManager = CMMotionActivityManager()
    let cloudKitHelper = CloudKitHelper()
    
    let lengthFormatter = NSLengthFormatter()
    
    var altChange: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudKitHelper.saveNote()
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Do any additional setup after loading the view, typically from a nib.
            lengthFormatter.numberFormatter.usesSignificantDigits = false
            lengthFormatter.numberFormatter.maximumSignificantDigits = 2
            lengthFormatter.unitStyle = .Short
            
            
            // Prepare altimeter
            altimeter.startRelativeAltitudeUpdatesToQueue(dataProcessingQueue) {
                (data, error) in
                if error != nil {
                    print("There was an error obtaining altimeter data: \(error)")
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.altChange += (data!.relativeAltitude as? Double)!
                        self.altitudeLabel.text = "\(self.lengthFormatter.stringFromMeters(self.altChange))"
                    }
                }
            }
            
            // Prepare pedometer
            pedometer.startPedometerUpdatesFromDate(NSDate()) {
                (data, error) in
                if error != nil {
                    print("There was an error obtaining pedometer data: \(error)")
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.floorsLabel.text = "\(data!.floorsAscended)"
                        self.stepsLabel.text = "\(data!.numberOfSteps)"
                        self.distanceLabel.text = "\(self.lengthFormatter.stringFromMeters(data!.distance as! Double))"
                    }
                }
            }
            
            // Prepare activity updates
            activityManager.startActivityUpdatesToQueue(dataProcessingQueue) {
                data in
                dispatch_async(dispatch_get_main_queue()) {
                    if data!.running {
                        self.activityImageView.image = UIImage(named: "run")
                    } else if data!.cycling {
                        self.activityImageView.image = UIImage(named: "cycle")
                    } else if data!.walking {
                        self.activityImageView.image = UIImage(named: "walk")
                    } else {
                        self.activityImageView.image = nil
                    }
                }
            }
        }
        
//        HealthKitHelper().recentSteps() { steps, error in
//           self.stepsTextForDay.text = String(steps)
//        }
//        
//        HealthKitHelper().recentDistance() { distance, error in
//            self.distanceTravelledTodayText.text = String(distance)
//        }
        
    }

    
    
    
    
}