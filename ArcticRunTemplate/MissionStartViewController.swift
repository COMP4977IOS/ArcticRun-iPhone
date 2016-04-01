//
//  MissionStartViewController.swift
//  ArcticRunTemplate
//
//  Created by Matt Wiseman on 2016-03-30.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import Foundation
import UIKit

class MissionStartViewController : UIViewController, UIViewControllerTransitioningDelegate {
    
    var toPass : String!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var missionPic: UIImageView!
    @IBOutlet weak var missionText: UILabel!
    @IBOutlet weak var begin: UIButton!
    @IBOutlet weak var missionSynop: UITextView!
    
    
    let customPresentAnimationController = CustomPresentAnimationController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMission()
        loadBG()
        
        // Label will display whatever is selected
        missionText.font = UIFont(name:"Noteworthy", size: 36)
        missionText.text = toPass
        
        
        //TextView
        missionSynop.editable = false
        

        
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
    
    // Will display appropriate picture, mission synopsis based on user choice
    func loadMission() {

        
        if(toPass == "Scott Hut") {
            
            missionPic.image = UIImage(named: "Reconnaissance")
            missionSynop.text = "Yourself, Joyce, and Richards have been tasked to travel to Scott Hut and assess its potential as a base of operations. After being confined to the ship for weeks, this will be a welcome change."
            
            
        }else if(toPass == "The Ship") {
            
            missionPic.image = UIImage(named: "OldWoodenShip")
            missionSynop.text = "After discovering Scott Hut in good condtion, travel back to the ship and inform the expedtion of your findings."
            
        }else{}
        
    }
    
    
    func loadBG() {
        
        // Gradient Background color
        let background = CAGradientLayer().blueblendColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        func beginMission(sender: AnyObject) {
            
            if(segue.identifier == "showAction") {
                
                // TODO: this portion is what assists in passing the label data,
                // it is not working for some reason albeit being the same as how
                // "text" data is passed from GameMap to MissionScreenController
                let navVC2 = segue.destinationViewController as! UINavigationController
                let svc2 = navVC2.topViewController as! PlayScreenViewController
                
                svc2.passData = missionText.text
                
                let toViewController = segue.destinationViewController as UIViewController
                toViewController.transitioningDelegate = self
                
            }
        }
    }
    
    
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPresentAnimationController
    }
    
}
