    //
    //  AddRegionViewController.swift
    //  Geofencing
    //
    //  Created by shishir sapkota on 5/23/16.
    //  Copyright © 2016 shishir sapkota. All rights reserved.
    //
    
    import UIKit
    import MapKit
    
    
    // struct that holds the coortinate of all the annotations placed for the location
    struct PolyRegion {
        var title = String()
        var vertices = [CLLocationCoordinate2D]()
        mutating func addVertice(vertice: CLLocationCoordinate2D){
            self.vertices.append(vertice)
        }
        
        func Vertices()-> [CLLocationCoordinate2D] {
            return self.vertices
        }
    }
    
    
    //protocol to take all the location information to other viewController
    protocol RegionDelegate {
        func userdidAddRegion(region:PolyRegion)
    }
    
    
    // main View controller
    class AddRegionViewController: UIViewController, RegionNameDelegate, MKMapViewDelegate {
        var pointArray: Array<CGPoint> = []
        var locationManager = CLLocationManager()
        @IBOutlet weak var mpView: MKMapView!
        var allPoints: Array<CGPoint> = []
        // protocols delegate
        var delegate:RegionDelegate? = nil
        
        //holds all the coordinate for the location
        var polyRegion = PolyRegion()
        var annotationTitle: String?
        override func viewDidLoad() {
            super.viewDidLoad()
            mpView.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            mpView.showsUserLocation = true
            let rightBtn = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
            self.navigationItem.rightBarButtonItem = rightBtn
            let saveBtn = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "save")
            self.navigationItem.leftBarButtonItem = saveBtn
        }
        
        
        
        
        @IBAction func btnAddPin(sender: UILongPressGestureRecognizer) {
            if sender.state == .Began{
                let location = sender.locationInView(mpView)
                
                let locationCordinate = self.mpView.convertPoint(location, toCoordinateFromView: self.mpView)
                polyRegion.addVertice(locationCordinate)
                
                
                var vertices = polyRegion.Vertices()
                print(vertices)
                let line = MKPolygon(coordinates: &vertices, count: vertices.count)
                
                mpView.addOverlays([line], level: .AboveRoads)
                
                // create annotations and add
                let annotation = MKPointAnnotation()
                annotation.coordinate = locationCordinate
                self.mpView.addAnnotation(annotation)
            }
        }
        
        
        
        func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
            
            let polylineRenderer = MKPolygonRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            polylineRenderer.fillColor = UIColor.blueColor()
            
            
            return polylineRenderer
            
        }
        
        func save(){
            
            
            self.delegate?.userdidAddRegion(self.polyRegion)
            self.navigationController?.popViewControllerAnimated(true)
            
            
        }
        
        
        func cancel() {
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
            
        }
        
        func AddRegionTitle(title: String) {
            polyRegion.title = title
            annotationTitle = title
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        
        @IBAction func btnAddTitle(sender: AnyObject) {
            let locationTitleViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LocationTitleViewController") as! LocationTitleViewController
            locationTitleViewController.delegate = self
            
            self.navigationController?.pushViewController(locationTitleViewController, animated: true)
            
        }
        
        
        
        
    }
    
