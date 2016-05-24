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
class ViewController: UIViewController, CLLocationManagerDelegate, RegionDelegate {

   var locationManager = CLLocationManager()

    @IBOutlet weak var mpView: MKMapView!
    
   
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
    
    func userdidAddRegion(region: PolyRegion) {
        
        
        let annotationLocations = region.vertices
        print(region.vertices.count)
        for location in annotationLocations{
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = region.title
            mpView.addAnnotation(annotation)
        }
    }
    
    @IBAction func addRegion(sender: AnyObject) {
        
        let addRegionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddRegionViewController") as! AddRegionViewController
        addRegionViewController.delegate = self
        
//        let nav = UINavigationController.init(rootViewController: addRegionViewController!)
        self.navigationController?.pushViewController(addRegionViewController, animated: true)
    }


}

