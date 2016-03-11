//
//  SelfieViewController.swift
//  ArcticRunTemplate
//
//  Created by Jox Toyod on 2016-03-05.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit

class SelfieViewController: UIViewController, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate
 {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        picker.cameraDevice =  UIImagePickerControllerCameraDevice.Front
        
        presentViewController(picker, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let imageToSave: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
   
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        
        self.savedImageAlert()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func savedImageAlert()
    {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll"
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
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
