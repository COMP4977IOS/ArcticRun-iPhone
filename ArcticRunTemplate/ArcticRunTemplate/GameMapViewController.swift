//
//  GameMapViewController.swift
//  ArcticRunTemplate
//
//  Created by Matt Wiseman on 2016-03-30.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import AVKit
import AVFoundation

class GameMapViewController: UIViewController {
    
    @IBOutlet weak var scrollVieew: UIScrollView!
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    let numberOfButtons = 10
    var missionTitle: String!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        // ---------- SETUP ----------
        
        imageView = UIImageView(image: UIImage(named: "gamemap.png"))
        imageView.frame = CGRectMake(0, 0, 1451, 1104)
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        // ---------- BUTTONS ----------
        
        // first button (scott hut)
        let frame1 = CGRect(x: 495, y: 340, width: 30, height: 30 )
        let button1 = UIButton(frame: frame1)
        button1.setTitle("x", forState: .Normal)
        button1.backgroundColor = UIColor.redColor()
        button1.addTarget(self, action: "pressed1:", forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(button1)
        
        // second button (back to ship)
        let frame2 = CGRect(x: 340, y: 426, width: 30, height: 30 )
        let button2 = UIButton(frame: frame2)
        button2.setTitle("x", forState: .Normal)
        button2.backgroundColor = UIColor.redColor()
        button2.addTarget(self, action: "pressed2:", forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(button2)
        
        // third button (hut point)
        let frame3 = CGRect(x: 540, y: 585, width: 30, height: 30 )
        let button3 = UIButton(frame: frame3)
        button3.setTitle("x", forState: .Normal)
        button3.backgroundColor = UIColor.redColor()
        button3.addTarget(self, action: "pressed3:", forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(button3)
        
        // fourth button (safety camp)
        let frame4 = CGRect(x: 545, y: 700, width: 30, height: 30 )
        let button4 = UIButton(frame: frame4)
        button4.setTitle("x", forState: .Normal)
        button4.backgroundColor = UIColor.redColor()
        button4.addTarget(self, action: "pressed4:", forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(button4)
        
        // fifth button (corner camp)
        let frame5 = CGRect(x: 820, y: 705, width: 30, height: 30 )
        let button5 = UIButton(frame: frame5)
        button5.setTitle("x", forState: .Normal)
        button5.backgroundColor = UIColor.redColor()
        button5.addTarget(self, action: "pressed5:", forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(button5)
        
        // sixth button (minna bluff depot)
        let frame6 = CGRect(x: 890, y: 1050, width: 30, height: 30 )
        let button6 = UIButton(frame: frame6)
        button6.setTitle("x", forState: .Normal)
        button6.backgroundColor = UIColor.redColor()
        button6.addTarget(self, action: "pressed6:", forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(button6)
            
        self.view.bringSubviewToFront(navBar)
            
            
            print("\n\n PLAYING AUDIO")
            /*
            let fileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("preface", ofType: "mp3")!)
            do{
                let audioPlayer : AVAudioPlayer = try AVAudioPlayer(contentsOfURL: fileURL)
                audioPlayer.play()
            } catch{
                print("ERROR PLAYING")
            }
            */
            
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                print("AVAudioSession Category Playback OK")
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("AVAudioSession is Active")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            whichVideoPlay()
            
            
            
                    

    }
    
    
 

    // ---------- FUNCTIONS FOR BUTTONS ----------
    
    // first location (scott hut)
    func pressed1(sender: UIButton!) {
        missionTitle = "Scott Hut"
        performSegueWithIdentifier("missionStart", sender: self)
        let alert = UIAlertController(title: "Scott Hut", message: "First Location", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // second location (the ship)
    func pressed2(sender: UIButton!) {
        missionTitle = "The Ship"
        performSegueWithIdentifier("missionStart", sender: self)
        let alert = UIAlertController(title: "The Ship", message: "Second Location", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // third location (hut point)
    func pressed3(sender: UIButton!) {
        missionTitle = "Hut Point"
        performSegueWithIdentifier("missionStart", sender: self)
        let alert = UIAlertController(title: "Hut Point", message: "Third Location", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // fourth location (safety camp)
    func pressed4(sender: UIButton!) {
        missionTitle = "Saftey Camp"
        performSegueWithIdentifier("missionStart", sender: self)
        let alert = UIAlertController(title: "Safety Camp", message: "Fourth Location", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // fifth location (corner camp)
    func pressed5(sender: UIButton!) {
        missionTitle = "Corner Camp"
        performSegueWithIdentifier("missionStart", sender: self)
        let alert = UIAlertController(title: "Corner Camp", message: "Fifth Location", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // sixth location (minna bluff depot)
    func pressed6(sender: UIButton!) {
        missionTitle = "Minna Bluff Depot"
        performSegueWithIdentifier("missionStart", sender: self)
        let alert = UIAlertController(title: "Minna Bluff Depot", message: "Sixth Location", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "missionStart") {
            
            let navVC = segue.destinationViewController as! UINavigationController
            let svc = navVC.topViewController as! MissionStartViewController
            
            svc.toPass = missionTitle
            
        }
    }
    
    func whichVideoPlay(){
        playSpecificVideo("introduction")
    }
    
    var audioPlayer : AVAudioPlayer!
    
    func playSpecificVideo(fileName : String){
        do {
            print(fileName)
            let fileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: "mp3")!)
            try audioPlayer = AVAudioPlayer(contentsOfURL: fileURL)
            audioPlayer.play()
            print(fileURL)
        } catch{
            print("ERROR")
        }
    }
    
}
