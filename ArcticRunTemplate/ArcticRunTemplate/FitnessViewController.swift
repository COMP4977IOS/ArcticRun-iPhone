//
//  FitnessViewController.swift
//  ArcticRunTemplate
//
//  Created by Matt Wiseman on 2016-02-21.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit
import CloudKit
import SwiftCharts


class FitnessViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var weightImage: UIImageView!
    @IBOutlet weak var waterImage: UIImageView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var stepImage: UIImageView!
    @IBOutlet weak var caloriesBurnedValue: UILabel!
    @IBOutlet weak var distanceValue: UILabel!
    
    
    var db:CKDatabase!
    
    private var caloriesArray : [String] = []
    private var distanceArray : [String] = []
    private var statsDate : [String] = []
    private var weightDates : [String] = []
    private var weightValues : [String] = []
    private var waterDates : [String] = []
    private var waterValues : [String] = []
    private var chart: Chart? // arc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caloriesBurnedValue.text = "..."
        distanceValue.text = "..."
       
        db = CKContainer(identifier: "iCloud.com.terratap.arcticrun").publicCloudDatabase
        self.loadCloudData()

        if (self.revealViewController() != nil) {
            print("REVEAL")
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        print("button1 \(menuButton)")
        
        weightImage.image = UIImage(named: "weight")
        waterImage.image = UIImage(named: "water")
        stepImage.image = UIImage(named: "steps")
        
        self.showChart()
    }
    
    
    func loadCloudData(){
        let predicate:NSPredicate = NSPredicate(value: true)
        
        //QUERY WATER
        let queryWater:CKQuery = CKQuery(recordType: "Water", predicate: predicate)
        db.performQuery(queryWater, inZoneWithID: nil) { (records:[CKRecord]?, error:NSError?) -> Void in
            if error != nil || records == nil{
                return  //found errors
                //print(error)
                
            }else{
                print("======== PRINTING WEIGHT ===========")
                print(records)
                
                for data in records! {
                    
                    let st:Int = data.valueForKey("water") as! Int
                    
                    if let stDate = data.valueForKey("date") {
                        
                        print(stDate)
                        
                        let dateFormatter = NSDateFormatter()//3
                        
                        let theDateFormat = NSDateFormatterStyle.ShortStyle //5
                        //let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
                        
                        dateFormatter.dateStyle = theDateFormat//8
                        //dateFormatter.timeStyle = theTimeFormat//9
                        
                        let date = dateFormatter.stringFromDate(stDate as! NSDate)//11
                        
                        self.waterDates.append(date)
                    }
                    
                    self.waterValues.append("\(st) glasses")
                    
                }
            }
        }

        
        
        
        //QUERY WEIGHT
        let queryWeight:CKQuery = CKQuery(recordType: "Weight", predicate: predicate)
        db.performQuery(queryWeight, inZoneWithID: nil) { (records:[CKRecord]?, error:NSError?) -> Void in
            if error != nil || records == nil{
                return  //found errors
                //print(error)
                
            }else{
                print("======== PRINTING WEIGHT ===========")
                print(records)
            
                for data in records! {
                    
                    let st:Double = data.valueForKey("weight") as! Double
         
                    if let stDate = data.valueForKey("date") {
                        
                        print(stDate)
                        
                        let dateFormatter = NSDateFormatter()//3
                        
                        let theDateFormat = NSDateFormatterStyle.ShortStyle //5
                        //let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
                        
                        dateFormatter.dateStyle = theDateFormat//8
                        //dateFormatter.timeStyle = theTimeFormat//9
                        
                        let date = dateFormatter.stringFromDate(stDate as! NSDate)//11
                        
                        self.weightDates.append(date)
                    }
                    
                    self.weightValues.append(String(format:"%.0f",st) + " kg")
       
                }
            }
        }

        
        
        //create records variable with query.
        let query:CKQuery = CKQuery(recordType: "Workout", predicate: predicate)
        db.performQuery(query, inZoneWithID: nil) { (records:[CKRecord]?, error:NSError?) -> Void in
            if error != nil || records == nil{
                return  //found errors
                //print(error)
                
            }else{
                print("======== PRINTING RECORDS ===========")
                print(records)

                let calories:Double = records?.first?.objectForKey("caloriesBurned") as! Double
                let distance:Double = records?.first?.objectForKey("distance") as! Double
                
                for data in records! {
                    
                    
                    let st:Double = data.valueForKey("caloriesBurned") as! Double
                    let dist:Double = data.valueForKey("distance") as! Double
                    
                    if let stDate = data.valueForKey("startDate") {
                        
                        print(stDate)
                        
                        print("\(NSDate()) date today")
                        
                        let dateFormatter = NSDateFormatter()//3
                        
                        let theDateFormat = NSDateFormatterStyle.ShortStyle //5
                        //let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
                        
                        dateFormatter.dateStyle = theDateFormat//8
                        //dateFormatter.timeStyle = theTimeFormat//9
                        
                        let date = dateFormatter.stringFromDate(stDate as! NSDate)//11
                    
                        self.statsDate.append(date)
                    }
                    
                    
   
                    self.caloriesArray.append(String(format:"%.0f",st) + " Cal")
                    self.distanceArray.append(String(format:"%.2f", dist) + " km")
                    //self.statsDate.append(stDate)
                }
                 //print(self.caloriesArray)
                dispatch_async (dispatch_get_main_queue ()) {
                    self.caloriesBurnedValue.text = String(format:"%.0f", calories)
                    self.distanceValue.text = String(format:"%.0f", distance)
                    
                    
                }
            }
            
        }
        
    }
    
    func showChart() {
        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 0, to: 8, by: 2)
        )
        let chart = BarsChart(
            frame: CGRectMake(self.chartView.frame.origin.x, self.chartView.frame.origin.y + 100, self.chartView.frame.size.width, self.chartView.frame.size.height),
            chartConfig: chartConfig,
            xTitle: "",
            yTitle: "",
            bars: [
                ("M", 2),
                ("T", 4.5),
                ("W", 3),
                ("T", 5.4),
                ("F", 6.8),
                ("S", 0.5),
                ("S", 1.5)
            ],
            color: UIColor.redColor(),
            barWidth: 20
        )

        
        self.view.addSubview(chart.view)
        self.chart = chart
    }
    
    func getChartValues(){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "CaloriesDetail"){
            let viewController = segue.destinationViewController as! DetailStatsViewController
            viewController.statsArray = self.caloriesArray
            viewController.dateArray = self.statsDate
        }else if(segue.identifier == "distanceDetail"){
            let viewController = segue.destinationViewController as! DetailStatsViewController
            viewController.statsArray = self.distanceArray
            viewController.dateArray = self.statsDate
        }else if(segue.identifier == "recordWeight"){
            let viewController = segue.destinationViewController as! RecordsViewController
            viewController.recordType = "weight"
            viewController.recordValues = self.weightValues
            viewController.recordDates = self.weightDates
        }else if(segue.identifier == "recordWater"){
            let viewController = segue.destinationViewController as! RecordsViewController
            viewController.recordType = "water"
            viewController.recordValues = self.waterValues
            viewController.recordDates = self.waterDates
        }
    }


}
    

//    func addtoCloudKit(){
//        let currentDateTime = NSDate()
//        let myRecord = CKRecord(recordType: "Weight")
//        myRecord.setObject(180, forKey: "weight")
//        myRecord.setObject(currentDateTime, forKey: "date")
//       
//        db!.saveRecord(myRecord, completionHandler:
//            ({returnRecord, error in
//                if let err = error {
//                    print("Save Error" +
//                        err.localizedDescription)
//                } else {
//                    dispatch_async(dispatch_get_main_queue()) {
//                        print("Record saved successfully")
//                }
//   
//                }
//            }))
//    }

    /*
    // MARK: Navigation -
    
    // In a storyboard-based application,you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController
    // Pass the selected object to the new view controller
    }
    */
    
    
