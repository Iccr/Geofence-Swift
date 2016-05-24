//
//  ViewController.swift
//  Geofencing
//
//  Created by shishir sapkota on 5/23/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {

   var locationManager = CLLocationManager()

    @IBOutlet weak var mpView: MKMapView!
    
//    @IBAction func btnAddPin(sender: UILongPressGestureRecognizer) {
//        let location = sender.locationInView(mpView)
//        let locationCordinate = self.mpView.convertPoint(location, toCoordinateFromView: self.mpView)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = locationCordinate
//        
//        annotation.title = "test location"
//        self.mpView.addAnnotation(annotation)
//    }
//    
   
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // show my location when the map appears.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        mpView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func addRegion(sender: AnyObject) {
        
        let addRegionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddRegionViewController")
//        let nav = UINavigationController.init(rootViewController: addRegionViewController!)
        self.navigationController?.pushViewController(addRegionViewController!, animated: true)
    }


}

