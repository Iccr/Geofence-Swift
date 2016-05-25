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
class ViewController: UIViewController, CLLocationManagerDelegate, RegionDelegate, MKMapViewDelegate {

   var locationManager = CLLocationManager()
    @IBOutlet weak var mpView: MKMapView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // show my location when the map appears.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        mpView.showsUserLocation = true
        mpView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnTestPoint(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began{
            self.mpView.removeAnnotations(self.mpView.annotations)
            
            let location = sender.locationInView(mpView)
            
            let locationCordinate = self.mpView.convertPoint(location, toCoordinateFromView: self.mpView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCordinate
            
            self.mpView.addAnnotation(annotation)
        }

    }
    func userdidAddRegion(region: PolyRegion) {
        if(region.vertices.count>2){
        let annotationLocations = region.vertices
        print(region.vertices.count)
//        for location in annotationLocations{
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = location
//            annotation.title = region.title
//            mpView.addAnnotation(annotation)
//            
//            
//        }
        var vertices = annotationLocations
        print(vertices)
        let line = MKPolygon(coordinates: &vertices, count: vertices.count)
        mpView.addOverlays([line], level: .AboveRoads)
        }else{ print("no polygon detected")}
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        print("poly renderer")
        let polylineRenderer = MKPolygonRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blueColor()
        polylineRenderer.lineWidth = 4
        polylineRenderer.fillColor = UIColor.blueColor()
        return polylineRenderer
    }
    

    
    @IBAction func addRegion(sender: AnyObject) {
        
        let addRegionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddRegionViewController") as! AddRegionViewController
        addRegionViewController.delegate = self
        
//        let nav = UINavigationController.init(rootViewController: addRegionViewController!)
        self.navigationController?.pushViewController(addRegionViewController, animated: true)
    }


}

