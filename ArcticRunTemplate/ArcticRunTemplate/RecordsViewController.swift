//
//  RecordsViewController.swift
//  ArcticRunTemplate
//
//  Created by Jox Toyod on 2016-04-04.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit
import CloudKit

class RecordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recordImage: UIImageView!
    @IBOutlet weak var recordTextField: UITextField!
    @IBOutlet weak var recordAddBtn: UIButton!
    @IBOutlet weak var recordTitle: UINavigationBar!
    
    var recordType: String = "" // identify which segue
    var recordValues: [String] = []
    var recordDates: [String] = []
    
    var db:CKDatabase!
    
    @IBAction func cancelBtn(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = CKContainer(identifier: "iCloud.com.terratap.arcticrun").publicCloudDatabase
        
        if recordType == "weight"{
            recordImage.image = UIImage(named: "weight")
            recordAddBtn.backgroundColor = UIColor(red: 52.0/255, green: 171.0/255, blue: 110.0/255, alpha: 1.0)
            recordTextField.placeholder = "Enter Weight in kg"
            recordTitle.topItem?.title = "Record Weight"
        }else if recordType == "water"{
            recordImage.image = UIImage(named: "water")
            recordAddBtn.backgroundColor = UIColor(red: 66.0/255, green: 186.0/255, blue: 255.0/255, alpha: 1.0)
            recordTextField.placeholder = "Enter Amount of water consumed"
            recordTitle.topItem?.title = "Record Water"
        }
        
    }
    
    @IBAction func addBtn(sender: AnyObject) {
        
        if recordType == "weight" {
            if let value = Double(recordTextField.text!) {
                addtoCloudKit(value)
            }else{
                self.showAlert("Record Weight", message: "Invalid Input")
            }
            
        }else if recordType == "water" {
            if let value = Int(recordTextField.text!) {
                addtoCloudKit(value)
            }else{
                self.showAlert("Record Water", message: "Invalid Input")
            }
        }
    }
    
    func showAlert(recordType: String, message : String){
        let alertController = UIAlertController(title: recordType, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func addtoCloudKit(value : NSObject){
        let currentDateTime = NSDate()
        
        var record : CKRecord!
        
        if(recordType == "weight"){
            
            record = CKRecord(recordType: "Weight")
            record.setObject(value as! Double, forKey: "weight")
        }else if(recordType == "water"){
            record = CKRecord(recordType: "Water")
            record.setObject(value as! Int, forKey: "water")
        }
        
        record!.setObject(currentDateTime, forKey: "date")
        
        db!.saveRecord(record, completionHandler:
            ({returnRecord, error in
                if let err = error {
                    print("Save Error" +
                        err.localizedDescription)
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        print("Record saved successfully")
                        self.showAlert("Record", message: "Record saved successfully")
                        self.recordTextField.text = ""
                    }
                    
                }
            }))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordValues.count   }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("recordCell", forIndexPath: indexPath) as! recordsCell
        cell.recordDate.text = recordDates[indexPath.row]
        cell.recordData.text = recordValues[indexPath.row]
        return cell
        
    }
}
