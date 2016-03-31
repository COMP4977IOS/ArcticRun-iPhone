//
//  PlayScreenViewController.swift
//  ArcticRunTemplate
//
//  Created by Matt Wiseman on 2016-03-30.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import Foundation
import UIKit

class PlayScreenViewController : UIViewController {
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    var passData : String!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let imagePause = UIImage(named:"Pause") as UIImage?
    let imagePlay = UIImage(named: "Play") as UIImage?
    let imageStop = UIImage(named: "Stop") as UIImage?
    
    var running = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBG()
        playBtn.setImage(imagePlay, forState: UIControlState.Normal)
        stopBtn.setImage(imageStop, forState: UIControlState.Normal)
        playGame()
        
        // TODO: Pass data from MissionViewController to label, not working like it is from GameMap
        //titleLabel.text = passData
        
        titleLabel.text = "Passed Label Data"
        
        
        
    }
    
    
    func playGame() {
        
        playBtn.setImage(imagePlay, forState: UIControlState.Normal)
        running = true
        
    }
    
    func pause() {
        
        playBtn.setImage(imagePause, forState: UIControlState.Normal)
        running = false
        
        
    }
    
    @IBAction func playAndPause(sender: AnyObject) {
        
        if(running == false) {
            
            return playGame()
            
        }else{
            
            return pause()
            
        }
    }
    
    @IBAction func stopGame(sender: AnyObject) {
        let alert = UIAlertController(title: "The Ship", message: "Are you sure you want to quit?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.Default, handler: { dismiss }()))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadBG() {
        
        // Gradient Background color
        let background = CAGradientLayer().blueblendColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
    }
    
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
