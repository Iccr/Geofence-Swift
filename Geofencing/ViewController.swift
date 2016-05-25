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

   
    @IBOutlet weak var mpView: MKMapView!
    var allLocationInfo = [PolyRegion]()
    var locationManager = CLLocationManager()
   
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
            var locationPoints = [CGPoint]()
            for singleLocation in allLocationInfo{
                var vertices = singleLocation.vertices
                for vertex in vertices {
                    locationPoints.append(self.mpView.convertCoordinate(vertex, toPointToView: self.mpView))
                }
            }
            if(contains(locationPoints, test: location)){
                print("it is inside a polygon")
            }else{
                print("the point is outside the polygon")
            }
        }

    }
    
    func contains(polygon: [CGPoint], test: CGPoint) -> Bool {
        if polygon.count <= 1 {
            return false //or if first point = test -> return true
        }
        
        let p = UIBezierPath()
        let firstPoint = polygon[0] as CGPoint
        
        p.moveToPoint(firstPoint)
        
        for index in 1...polygon.count-1 {
            p.addLineToPoint(polygon[index] as CGPoint)
        }
        
        p.closePath()
        
        return p.containsPoint(test)
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
            allLocationInfo.append(region)
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

