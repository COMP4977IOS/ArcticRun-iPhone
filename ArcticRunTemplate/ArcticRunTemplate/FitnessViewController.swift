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
    @IBOutlet weak var dailyStepsCounter: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
    var db:CKDatabase!
    
    private var caloriesArray : [String] = []
    private var distanceArray : [String] = []
    private var statsDate : [String] = []
    private var weightDates : [String] = []
    private var weightValues : [String] = []
    private var waterDates : [String] = []
    private var waterValues : [String] = []
    private var pastDatesValues : [(String,Double)]=[]
    private var stepsToday: Int = 0
    private var chart: Chart? // arc
    private var lastestValues: (calorie:Double, distance:Double) = (0,0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caloriesBurnedValue.text = "..."
        distanceValue.text = "..."
        dailyStepsCounter.text = "..."
        
        db = CKContainer(identifier: "iCloud.com.terratap.arcticrun").publicCloudDatabase
        self.loadCloudData()
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        weightImage.image = UIImage(named: "weight")
        waterImage.image = UIImage(named: "water")
        stepImage.image = UIImage(named: "steps")
        
        activityIndicator.startAnimating()
    }
    
    
    func loadCloudData(){
        let predicate:NSPredicate = NSPredicate(value: true)
        
        //QUERY WATER
        let queryWater:CKQuery = CKQuery(recordType: "Water", predicate: predicate)
        queryWater.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        db.performQuery(queryWater, inZoneWithID: nil) { (records:[CKRecord]?, error:NSError?) -> Void in
            if error != nil || records == nil{
                return  //found errors
            }else{
                for data in records! {
                    
                    let st:Int = data.valueForKey("water") as! Int
                    
                    if let stDate = data.valueForKey("date") {
                        
                        let dateFormatter = NSDateFormatter()//3
                        let theDateFormat = NSDateFormatterStyle.ShortStyle //5
                        dateFormatter.dateStyle = theDateFormat
                        let date = dateFormatter.stringFromDate(stDate as! NSDate)//11
                        
                        self.waterDates.append(date)
                    }
                    
                    self.waterValues.append("\(st) glasses")
                }
            }
        }
        
        //QUERY WEIGHT
        let queryWeight:CKQuery = CKQuery(recordType: "Weight", predicate: predicate)
        queryWeight.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        db.performQuery(queryWeight, inZoneWithID: nil) { (records:[CKRecord]?, error:NSError?) -> Void in
            if error != nil || records == nil{
                return  //found errors
            }else{
                for data in records! {
                    
                    let st:Double = data.valueForKey("weight") as! Double
                    
                    if let stDate = data.valueForKey("date") {
                        let dateFormatter = NSDateFormatter()//3
                        let theDateFormat = NSDateFormatterStyle.ShortStyle
                        dateFormatter.dateStyle = theDateFormat//8
                        let date = dateFormatter.stringFromDate(stDate as! NSDate)//11
                        self.weightDates.append(date)
                    }
                    self.weightValues.append(String(format:"%.0f",st) + " kg")
                }
            }
        }
        
        //create records variable with query.
        let query:CKQuery = CKQuery(recordType: "Workout", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        db.performQuery(query, inZoneWithID: nil) { (records:[CKRecord]?, error:NSError?) -> Void in
            if error != nil || records == nil{
                return  //found errors
            }else{
                let lastestDate = records?.first?.valueForKey("startDate")
                var getDates = self.getPastDates()
                let dateFormatter = NSDateFormatter()
                let theDateFormat = NSDateFormatterStyle.ShortStyle
                dateFormatter.dateStyle = theDateFormat

                for data in records! {
                    
                    let st:Double = data.valueForKey("caloriesBurned") as! Double
                    let dist:Double = data.valueForKey("distance") as! Double
                    let steps:Int = data.valueForKey("steps") as! Int
                    
                    if let stDate = data.valueForKey("startDate") {
                        
                        let date = dateFormatter.stringFromDate(stDate as! NSDate)//11
                        
                        self.statsDate.append(date)
                        
                        if(date == dateFormatter.stringFromDate(lastestDate as! NSDate)){
                            self.lastestValues.calorie += st
                            self.lastestValues.distance += dist
                        }
                        
                        if (getDates[date] != nil){
                            getDates[date]! += Double(steps)
                        }
                        
                        if date == dateFormatter.stringFromDate(NSDate()){
                            self.stepsToday += steps
                        }
                    }
                    
                    self.caloriesArray.append(String(format:"%.0f",st) + " Cal")
                    self.distanceArray.append(String(format:"%.2f", dist) + " km")
                }
                
                self.pastDatesValues = getDates.sort{ dateFormatter.dateFromString($0.0)!.compare(dateFormatter.dateFromString($1.0)!) == .OrderedAscending}
                
                dispatch_async (dispatch_get_main_queue ()) {
                    
                    self.caloriesBurnedValue.text = String(format:"%.0f", self.lastestValues.calorie)
                    self.distanceValue.text = String(format:"%.1f", self.lastestValues.distance)
                    self.dailyStepsCounter.text = "\(self.stepsToday)/5000 steps"
                    
                    for i in 0 ... 6 {
                        self.pastDatesValues[i].1 = self.pastDatesValues[i].1/1000
                    }
                    
                    self.showChart()
                }
            }
        }
    }
    
    func showChart() {
        activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 0, to: 8, by: 2)
            
        )
        let chart = BarsChart(
            frame: CGRectMake(self.chartView.frame.origin.x, self.chartView.frame.origin.y + 90, self.chartView.frame.size.width, self.chartView.frame.size.height),
            chartConfig: chartConfig,
            xTitle: "steps taken in the past 7 days",
            yTitle: "",
            bars: [
                ("1", self.pastDatesValues[0].1),
                ("2", self.pastDatesValues[1].1),
                ("3", self.pastDatesValues[2].1),
                ("4", self.pastDatesValues[3].1),
                ("5", self.pastDatesValues[4].1),
                ("6", self.pastDatesValues[5].1),
                ("7", self.pastDatesValues[6].1)
            ],
            color: UIColor.redColor(),
            barWidth: 20
        )
        
        self.view.addSubview(chart.view)
        self.chart = chart
    }
    
    func getPastDates() -> [String:Double]{
        
        
        var dates = [String:Double]()
        var dates2 = [NSDate:Int]()
        let dateFormatter = NSDateFormatter()
        let theDateFormat = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateStyle = theDateFormat
        
        for i in 2 ... 8 {
            // move back in time by one day:
            let backDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -i, toDate: NSDate(), options: [])!
            dates2[backDate] = 0
            let date = dateFormatter.stringFromDate(backDate)
            dates[date] =  0
            
        }
        
        return dates
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "CaloriesDetail"){
            let viewController = segue.destinationViewController as! DetailStatsViewController
            viewController.statsArray = self.caloriesArray
            viewController.dateArray = self.statsDate
            viewController.id = "cal"
        }else if(segue.identifier == "distanceDetail"){
            let viewController = segue.destinationViewController as! DetailStatsViewController
            viewController.statsArray = self.distanceArray
            viewController.dateArray = self.statsDate
            viewController.id = "dist"
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
