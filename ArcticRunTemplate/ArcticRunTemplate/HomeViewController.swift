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
    
    
}


    /*
    // MARK: Navigation -

    // In a storyboard-based application,you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController
    // Pass the selected object to the new view controller
    }
    */
