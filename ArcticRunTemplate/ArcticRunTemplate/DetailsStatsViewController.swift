//
//  DetailStatsViewController.swift
//  ArcticRunTemplate
//
//  Created by Jox Toyod on 2016-04-03.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit
import CloudKit

class DetailStatsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBAction func btnCancel(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    var statsArray : [String] = []
    var dateArray  : [String] = []
    
    var i : Int = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        i = statsArray.count
        print(dateArray)
        // Do any additional setup after loading the view.
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dateArray.count)
        return i   }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("calorieCell", forIndexPath: indexPath) as! CalorieCell
        cell.date.text = dateArray[indexPath.row]
        cell.calorieCell.text = statsArray[indexPath.row]
        return cell
        
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
