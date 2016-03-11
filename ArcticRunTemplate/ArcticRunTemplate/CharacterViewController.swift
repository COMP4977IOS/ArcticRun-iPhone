//
//  PartyController.swift
//  ArcticRunTemplate
//
//  Created by Ricky Chen on 3/3/16.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var health: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var nameString : String = ""
    var healthString : String = ""
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        name.text = nameString
        health.text = healthString
        imageView.image = image
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}
