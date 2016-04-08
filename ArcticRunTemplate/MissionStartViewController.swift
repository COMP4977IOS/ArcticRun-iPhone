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
    var chapterNum : Int?
    private let manager = GameConfigManager()
    
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
        missionPic.layer.cornerRadius = 5
        missionPic.layer.borderWidth = 1
        missionPic.layer.borderColor = UIColor.blackColor().CGColor
        
        missionSynop.layer.cornerRadius = 5
        missionSynop.layer.borderWidth = 1
        missionSynop.layer.borderColor = UIColor.blackColor().CGColor
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
        if(toPass == "The Ship") {
            manager.loadLevel(1)
            chapterNum = 1
            
        }
        else if(toPass == "Scott Hut") {
            manager.loadLevel(2)
            chapterNum = 2
        }
        
        if (chapterNum != nil) {
            let levelInfo:NSDictionary = manager.getLevelInfo()!
            missionPic.image = UIImage(named: levelInfo["image"] as! String)
            missionSynop.text = levelInfo["description"] as! String
        }
    }
    
    func loadBG() {
        
        // Gradient Background color
        let background = CAGradientLayer().blueblendColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        func beginMission(sender: AnyObject) {
            if(segue.identifier == "showAction") {
                
                // TODO: this portion is what assists in passing the label data,
                // it is not working for some reason albeit being the same as how
                // "text" data is passed from GameMap to MissionScreenController
                let navVC2 = segue.destinationViewController as! UINavigationController
                let svc2 = navVC2.topViewController as! PlayScreenViewController
                print("LOADING PLAYSCREEN")
                print(missionText)
                
                svc2.passData = missionText.text
                
                let toViewController = segue.destinationViewController as UIViewController
                toViewController.transitioningDelegate = self
                
            }
        }
        */
        if(segue.identifier == "showAction") {
            
            // TODO: this portion is what assists in passing the label data,
            // it is not working for some reason albeit being the same as how
            // "text" data is passed from GameMap to MissionScreenController
            if let viewController2 = segue.destinationViewController as? PlayScreenViewController {
                viewController2.passData = missionText.text
                viewController2.chapterNum = chapterNum
            }
            
        }
    }
    
    
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPresentAnimationController
    }
    
}
