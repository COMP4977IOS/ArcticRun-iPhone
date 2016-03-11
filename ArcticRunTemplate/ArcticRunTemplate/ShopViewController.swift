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
    
    var tableData: [String] = ["500", "1000", "2000", "3000", "4000", "5000", "10000", "12500",
        "15000", "17500", "20000", "25000", "30000", "35000", "40000", "45000", "50000", "60000", "70000", "80000", "90000", "100000"]
    var tableImages: [String] = ["qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png",
        "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png",
        "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", ]
    
    let screenSize = UIScreen.mainScreen().bounds
    
    
    override func viewDidLoad() {

        currency1Label.text = "5000"
        currency2Label.text = "15000"
        currency1Label.textColor = UIColor.redColor()
        currency2Label.textColor = UIColor.blueColor()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        let screenWidth = screenSize.width
//        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
        return tableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: colvwCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! colvwCell

        cell.lblCell.text = tableData[indexPath.row]
        let image = UIImage(named: tableImages[indexPath.row])
        cell.imgCell.image = image
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
                let party1 = UIAlertAction(title: "Party Member 1", style: .Default, handler: { action in self.currency2Label.text = String(total! - price!) } )
                let party2 = UIAlertAction(title: "Party Member 2", style: .Default, handler: { action in self.currency2Label.text = String(total! - price!) } )
                let party3 = UIAlertAction(title: "Party Member 3", style: .Default, handler: { action in self.currency2Label.text = String(total! - price!) } )
                let party4 = UIAlertAction(title: "Party Member 4", style: .Default, handler: { action in self.currency2Label.text = String(total! - price!) } )
                let cancel = UIAlertAction(title: "Cancel", style: .Destructive) { (action) -> Void in print("cancelled") }
                alertController.addAction(party1)
                alertController.addAction(party2)
                alertController.addAction(party3)
                alertController.addAction(party4)
                alertController.addAction(cancel)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
