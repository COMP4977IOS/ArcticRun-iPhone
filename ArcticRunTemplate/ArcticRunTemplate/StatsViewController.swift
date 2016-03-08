//
//  StatsViewController.swift
//  ArcticRunTemplate
//
//  Created by Jox Toyod on 2016-03-05.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit
import CloudKit

class StatsViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var caloriesBurnedValue: UILabel!
    @IBOutlet weak var distanceValue: UILabel!
 
    
    var db:CKDatabase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = CKContainer(identifier: "iCloud.com.terratap.arcticrun").publicCloudDatabase
        
        self.loadCloudData()

        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        caloriesBurnedValue.text = "updating..."
        distanceValue.text = "updating..."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadCloudData(){
        let predicate:NSPredicate = NSPredicate(value: true)
        let query:CKQuery = CKQuery(recordType: "Workout", predicate: predicate)
        //create records variable with query.
        db.performQuery(query, inZoneWithID: nil) { (records:[CKRecord]?, error:NSError?) -> Void in
            if error != nil || records == nil{
                return  //found errors
                //print(error)
               
            }else{
                print(records)
                let calories:Double = records?.first?.objectForKey("caloriesBurned") as! Double
                let distance:Double = records?.first?.objectForKey("distance") as! Double
                dispatch_async (dispatch_get_main_queue ()) {
                    self.caloriesBurnedValue.text = String(format:"%.0f", calories)
                    self.distanceValue.text = String(format:"%.0f", distance)

                }
            }
            
        }
       
    }
    
   
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
