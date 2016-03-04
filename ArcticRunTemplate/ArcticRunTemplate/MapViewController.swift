//
//  MapViewController.swift
//  arcticrun
//
//  Created by Clyde Chen on 2016-02-18.
//  Copyright © 2016 COMP4977iPhoneTeam. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var label: UILabel!
    
    var manager : CLLocationManager!
    var myLocations : [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        // map setup
        map.delegate = self
        map.mapType = MKMapType.Satellite
        map.showsUserLocation = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // update label to display current location
        label.text = "\(locations[0])"
        myLocations.append(locations[0] as CLLocation)
        
        // specify the area displayed and zoom in
        let x = 0.005
        let y = 0.005
        // var vs let !!!
        let region = MKCoordinateRegion(center: map.userLocation.coordinate, span: MKCoordinateSpanMake(x, y))
        map.setRegion(region, animated: true)
        
        // specify source and destination for tracking purposes
        if(myLocations.count > 1){
            // var vs let again !!!
            let src = myLocations.count - 1
            let dest = myLocations.count - 2
            let c1 = myLocations[src].coordinate
            let c2 = myLocations[dest].coordinate
            var polylineCoordinates = [c1, c2]
            // add a polyline connecting src to dest to the map
            let polyline = MKPolyline(coordinates: &polylineCoordinates, count: polylineCoordinates.count)
            map.addOverlay(polyline)
            
        }
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = MKPolylineRenderer(overlay: overlay)
        polyline.strokeColor = UIColor.greenColor()
        return polyline
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
