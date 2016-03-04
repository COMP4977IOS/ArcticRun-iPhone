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
    @IBOutlet weak var currency1: UILabel!
    @IBOutlet weak var currency2: UILabel!
    
    var tableData: [String] = ["500", "1000", "2000", "3000", "4000", "5000", "10000", "12500",
        "15000", "17500", "20000", "25000", "30000", "35000", "40000", "45000", "50000", "60000", "70000", "80000", "90000", "100000"]
    var tableImages: [String] = ["qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png",
        "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png",
        "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", "qmitem.png", ]
    
    
    override func viewDidLoad() {
        
        currency1.text = "10000"
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let priceString = tableData[indexPath.row]
        let price = Int(priceString)
        let totalString = currency1.text
        let total = Int(totalString!)
        
        if(price > total) {
            let alertController = UIAlertController(title: "Item \(indexPath.row + 1)", message: "You do not have enough points.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Destructive) { (action) -> Void in print("test") }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Item \(indexPath.row + 1)", message: "Purchase?", preferredStyle:
                .ActionSheet)
            let party1 = UIAlertAction(title: "Party Member 1", style: .Default, handler: { action in self.currency1.text = String(total! - price!) } )
            let party2 = UIAlertAction(title: "Party Member 2", style: .Default, handler: { action in self.currency1.text = String(total! - price!) } )
            let party3 = UIAlertAction(title: "Party Member 3", style: .Default, handler: { action in self.currency1.text = String(total! - price!) } )
            let party4 = UIAlertAction(title: "Party Member 4", style: .Default, handler: { action in self.currency1.text = String(total! - price!) } )
            alertController.addAction(party1)
            alertController.addAction(party2)
            alertController.addAction(party3)
            alertController.addAction(party4)
            self.presentViewController(alertController, animated: true, completion: nil)

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
