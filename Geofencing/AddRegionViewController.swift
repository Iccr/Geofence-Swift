    //
    //  AddRegionViewController.swift
    //  Geofencing
    //
    //  Created by shishir sapkota on 5/23/16.
    //  Copyright © 2016 shishir sapkota. All rights reserved.
    //
    
    import UIKit
    import MapKit
    

    //protocol to take all the location information to other viewController
    protocol RegionDelegate {
        func userdidAddRegion(region:PolyRegion)
    }
    
    // main View controller
    class AddRegionViewController: UIViewController, RegionNameDelegate, MKMapViewDelegate {
        
        @IBOutlet weak var mpView: MKMapView!
        @IBOutlet weak var btnDetail: UIButton!
        @IBOutlet weak var btnFindMe: UIButton!
        
        @IBOutlet weak var zoomSlider: UISlider!
        var annotationTitle: String?
        var latitude: Double?
        var longitude: Double?
        var center: CLLocationCoordinate2D?
        var delta:Float = 0.09
        var delegate:RegionDelegate? = nil
        
        var polyRegion = PolyRegion()
        var locationManager = CLLocationManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            initZoomSlider()
            initMapView()
            initManager()
            setBtnRadious()
            initNavigationMenu()
        }
        
        func initNavigationMenu(){
            let saveBtn = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(AddRegionViewController.save))
            saveBtn.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationItem.rightBarButtonItem = saveBtn
        }
        
        func setBtnRadious(){
            btnDetail.layer.cornerRadius = 0.5 * btnDetail.bounds.size.width
            btnFindMe.layer.cornerRadius = 0.5 * btnFindMe.bounds.size.width
        }
        
        func initZoomSlider(){
            zoomSlider.setValue(delta, animated: false)
        }
        
        func initMapView(){
            mpView.delegate = self
            mpView.showsUserLocation = true
            mpView.mapType = MKMapType.Satellite
            latitude = locationManager.location?.coordinate.latitude
            longitude = locationManager.location?.coordinate.longitude
            center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            centerMapOnLocation(center!)
        }
        
        func initManager(){
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        @IBAction func btnAddPin(sender: UILongPressGestureRecognizer) {
            if sender.state == .Began{
                let location = sender.locationInView(mpView)
                let locationCordinate = self.mpView.convertPoint(location, toCoordinateFromView: self.mpView)
                polyRegion.addVertice(locationCordinate)
                var vertices = polyRegion.Vertices()
                let line = MKPolygon(coordinates: &vertices, count: vertices.count)
                mpView.addOverlays([line], level: .AboveRoads)
                let annotation = MKPointAnnotation()
                annotation.coordinate = locationCordinate
                self.mpView.addAnnotation(annotation)
            }
        }
        
        @IBAction func btnAddTitle(sender: AnyObject) {
            let locationTitleViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LocationTitleViewController") as! LocationTitleViewController
            locationTitleViewController.delegate = self
            self.navigationController?.pushViewController(locationTitleViewController, animated: true)
        }
        
        @IBAction func btnFindMe(sender: UIButton) {
            centerMapOnLocation(center!)
        }
        @IBAction func btnSlider(sender: UISlider) {
            delta = sender.value
            centerMapOnLocation(center!)
        }
        
        func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
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
        
        func AddRegionTitle(title: String, description: String) {
            polyRegion.title = title
            polyRegion.description = description
            annotationTitle = title
        }
        
        func centerMapOnLocation(location: CLLocationCoordinate2D){
            let region =   MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(delta), longitudeDelta: CLLocationDegrees(delta)))
            mpView.setRegion(region, animated: true)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
    }
    
