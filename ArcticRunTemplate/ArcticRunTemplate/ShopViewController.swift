//
//  ShopViewController.swift
//  ArcticRunTemplate
//
//  Created by Ricky Chen on 3/3/16.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit

private let reuseIdentifier = "itemCell"

class ShopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!

    @IBOutlet weak var currency1: UIButton!
    @IBOutlet weak var currency2: UIButton!
    @IBOutlet weak var currency1Label: UILabel!
    @IBOutlet weak var currency2Label: UILabel!
    var useCur1 = true
    var current = 0
    
    var tableData: [String] = ["500", "1000", "2000", "3000", "4000", "5000", "10000", "12500",
        "15000", "17500", "20000", "25000", "30000", "35000", "40000", "50000"]

    var images = [UIImage(named: "Beetroot_Soup"), UIImage(named: "Bread"), UIImage(named: "Fish"),
                    UIImage(named: "Mushroom_Stew"), UIImage(named: "Cooked_Chicken"), UIImage(named: "Cooked_Fish"),
                    UIImage(named: "Cooked_Porkchop"), UIImage(named: "health_potion"), UIImage(named: "Hat"),
                    UIImage(named: "Coat"), UIImage(named: "iron_axe"), UIImage(named: "Iron_Pickaxe"),
                    UIImage(named: "Leather_Boots"), UIImage(named: "Leather_helmet"), UIImage(named: "Leather_Pants"),
                    UIImage(named: "Leather_chestplate")]
    
    let screenSize = UIScreen.mainScreen().bounds
    
    
    override func viewDidLoad() {
        
        currency1Label.text = "15000"
        currency1Label.textColor = UIColor.redColor()
        currency2Label.textColor = UIColor.blueColor()
        
        
        Crew.getAllCrews { (crews: [Crew]) -> Void in
            for var i = 0; i < crews.count; i++ {
                self.current = crews[i].getCaloriePoints()!
            }
            self.currency2Label.text = String(self.current)
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func updatePoints(price: Int) -> String {
        Crew.getAllCrews { (crews: [Crew]) -> Void in
            for var i = 0; i < crews.count; i++ {
                self.current = crews[i].getCaloriePoints()!
            }
        }
        let result = current - price
        Crew.getAllCrews { (crews: [Crew]) -> Void in
            for var i = 0; i < crews.count; i++ {
                crews[i].setCaloriePoints(result)
                crews[i].save()
            }
        }
        return String(result)
    }

    @IBAction func useCurrency1(sender: AnyObject) {
        if useCur1 == false {
            useCur1 = true
            currency1Label.textColor = UIColor.redColor()
            currency2Label.textColor = UIColor.blueColor()
        }
    }
    
    @IBAction func useCurrency2(sender: AnyObject) {
        if useCur1 == true {
            useCur1 = false
            currency1Label.textColor = UIColor.blueColor()
            currency2Label.textColor = UIColor.redColor()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: colvwCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! colvwCell

        cell.lblCell.text = tableData[indexPath.row]
        //let image = UIImage(named: tableImages[indexPath.row])
        cell.imgCell.image = images[indexPath.row]
        cell.frame.size.height = 120
        cell.frame.size.width = 120
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let screenWidth = screenSize.width
//        return CGSize(width: screenWidth/3, height: screenWidth/3);
//        
//    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let priceString = tableData[indexPath.row]
        let price = Int(priceString)
        if(isICloudContainerAvailable()){
            if useCur1 == true {
                let totalString = currency1Label.text
                let total = Int(totalString!)
                
                if(price > total) {
                    let alertController = UIAlertController(title: "Item \(indexPath.row + 1)", message: "You do not have enough points.", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Destructive) { (action) -> Void in print("test") }
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Item \(indexPath.row + 1)", message: "Purchase?", preferredStyle:
                        .ActionSheet)
                    let party1 = UIAlertAction(title: "Party Member 1", style: .Default, handler: { action in self.currency1Label.text = String(total! - price!) } )
                    let party2 = UIAlertAction(title: "Party Member 2", style: .Default, handler: { action in self.currency1Label.text = String(total! - price!) } )
                    let party3 = UIAlertAction(title: "Party Member 3", style: .Default, handler: { action in self.currency1Label.text = String(total! - price!) } )
                    let party4 = UIAlertAction(title: "Party Member 4", style: .Default, handler: { action in self.currency1Label.text = String(total! - price!) } )
                    let cancel = UIAlertAction(title: "Cancel", style: .Destructive) { (action) -> Void in print("cancelled") }
                    alertController.addAction(party1)
                    alertController.addAction(party2)
                    alertController.addAction(party3)
                    alertController.addAction(party4)
                    alertController.addAction(cancel)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                let totalString = currency2Label.text
                let total = Int(totalString!)
                
                if(price > total) {
                    let alertController = UIAlertController(title: "Item \(indexPath.row + 1)", message: "You do not have enough points.", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Destructive) { (action) -> Void in print("test") }
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Item \(indexPath.row + 1)", message: "Purchase?", preferredStyle:
                        .ActionSheet)
                    let party1 = UIAlertAction(title: "Party Member 1", style: .Default, handler: { action in self.currency2Label.text = self.updatePoints(price!) } )
                    let party2 = UIAlertAction(title: "Party Member 2", style: .Default, handler: { action in self.currency2Label.text = self.updatePoints(price!) } )
                    let party3 = UIAlertAction(title: "Party Member 3", style: .Default, handler: { action in self.currency2Label.text = self.updatePoints(price!) } )
                    let party4 = UIAlertAction(title: "Party Member 4", style: .Default, handler: { action in self.currency2Label.text = self.updatePoints(price!) } )
                    let cancel = UIAlertAction(title: "Cancel", style: .Destructive) { (action) -> Void in print("cancelled") }
                    alertController.addAction(party1)
                    alertController.addAction(party2)
                    alertController.addAction(party3)
                    alertController.addAction(party4)
                    alertController.addAction(cancel)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }else{
            let myalert = UIAlertController(title: "iCloud Account", message: "Please loggin to your iCloud Account",preferredStyle: UIAlertControllerStyle.Alert);
            
            let dismissAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){(ACTION) in print("ok button tapped");
            }
            
            myalert.addAction(dismissAction);
            
            self.presentViewController(myalert, animated:true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isICloudContainerAvailable()->Bool {
        if let currentToken = NSFileManager.defaultManager().ubiquityIdentityToken {
            return true
        }
        else {
            return false
        }
    }

}
