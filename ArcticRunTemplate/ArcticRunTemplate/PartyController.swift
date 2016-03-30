//
//  PartyController.swift
//  ArcticRunTemplate
//
//  Created by Ricky Chen on 3/3/16.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit

class PartyController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var names : [String] = ["Aeneas Mackintosh", "Dick Richards", "Ernest Joyce", "John Stenhouse","Arnold Spencer-Smith"]
    var health : [String] = ["Status: Healthy","Status: Sick","Status: Hungry","Status: Dead","Status: Sick"]
    var images = [UIImage(named: "Aeneas-Mackintosh"),UIImage(named:"Dick-Richards"),UIImage(named:"Ernest-Joyce"),UIImage(named:"John-Stenhouse"),UIImage(named:"Spencer-Smith")]
    
    var selectedName : String = ""
    var selectedHealth : String = ""
    var selectedImage : UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("mycell", forIndexPath: indexPath) as! PartyCell
        cell.name.text = names[indexPath.row]
        cell.status.text = health[indexPath.row]
        cell.photo.image = images[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segue"){
            if let indexPath = tableView.indexPathForSelectedRow {
                selectedName = names[indexPath.row]
                selectedHealth = health[indexPath.row]
                selectedImage = images[indexPath.row]!
                
                let viewController = segue.destinationViewController as! CharacterViewController
                viewController.nameString = selectedName
                viewController.healthString = selectedHealth
                viewController.image = selectedImage
            }
        }
    }
    

}
