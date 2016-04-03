//
//  DetailStatsViewController.swift
//  ArcticRunTemplate
//
//  Created by Jox Toyod on 2016-04-03.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit

class DetailStatsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBAction func btnCancel(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
   
   var caloriesArray : [String] = []
    
    var i : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        i = caloriesArray.count

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {        
        print(caloriesArray)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(i)
        return i   }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! CalorieCell
        cell.calorieCell.text = "test"
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
