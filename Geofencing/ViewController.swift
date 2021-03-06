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
    
    var delta:Float = 0.09
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var mpView: MKMapView!
    @IBOutlet weak var btnFindMe: UIButton!
    
    @IBOutlet weak var zoomSlider: UISlider!
    
    var latitude: Double?
    var longitude: Double?
    var center: CLLocationCoordinate2D?
    var allLocationInfo = [PolyRegion]()
    var locationManager = CLLocationManager() //TODO: use abstract factory pattern
    var inside = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initZoomSlider() //TODO: may be builder pattern fits here
        initNavigationMenu()
        setBtnRadious()
        initManager()
        initMapView()
    }
    
    func initZoomSlider(){
        zoomSlider.setValue(delta, animated: false)
    }
    
    func initNavigationMenu(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func initMapView(){
        mpView.mapType = MKMapType.Hybrid
        mpView.showsUserLocation = true
        mpView.delegate = self
        latitude = locationManager.location?.coordinate.latitude
        longitude = locationManager.location?.coordinate.longitude
        center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        centerMapOnLocation(center!)
    }
    
    func initManager(){
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func setBtnRadious(){
        btnFindMe.layer.cornerRadius =  0.5 * btnFindMe.bounds.size.width
        btnAdd.layer.cornerRadius = 0.5 * btnAdd.bounds.size.width
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D){
        let region =   MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(delta), longitudeDelta: CLLocationDegrees(delta)))
        mpView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        latitude = location?.coordinate.latitude
        longitude = location?.coordinate.longitude
        center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let pointOnView: CGPoint = self.mpView.convertCoordinate(center!, toPointToView: self.mpView)
        checkAllLocationsForIntersection(pointOnView)
    }
    
    func checkAllLocationsForIntersection(point: CGPoint){
        for polygon in allLocationInfo{
            if(checkIntersection(point, region: polygon)){
                if(!inside){
                    print("you entered the region: \(polygon.title)")
                    notify(polygon.title, message: polygon.description)
                    inside = true
                }
            }else{
                if(inside){
                    print("you leaved the place \(polygon.title)")
                    notify(polygon.title, message: "bye bye")
                    inside = false
                }
            }
        }
    }
    
    func checkIntersection(point: CGPoint, region: PolyRegion) -> Bool {
        var locationPoints = [CGPoint]()
        let vertices = region.Vertices()
        for vertex in vertices{
            let locationPoint = self.mpView.convertCoordinate(vertex, toPointToView: self.mpView)
            locationPoints.append(locationPoint)
        }
        if(contains(locationPoints, test: point)){
            return true
        }else{
            return false
        }
    }
    
    func notify( title: String, message: String){
        if(self.isViewLoaded() && (self.view.window != nil)){
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 5)
            notification.alertTitle = title
            notification.alertBody = message
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            allLocationInfo.append(region)
            var vertices = annotationLocations
            let line = MKPolygon(coordinates: &vertices, count: vertices.count)
            mpView.addOverlays([line], level: .AboveRoads)
            let annotation = MKPointAnnotation() //TODO: user abstract factory pattern here
            annotation.coordinate = region.Vertices().first!
            annotation.title = region.title
            mpView.addAnnotation(annotation)
            
        }else{ print("no polygon detected")}
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolygonRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blueColor()
        polylineRenderer.lineWidth = 4
        polylineRenderer.fillColor = UIColor.blueColor()
        return polylineRenderer
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        center = mapView.centerCoordinate
    }
    
    func removeAnnotations(){
        self.mpView.removeAnnotations(self.mpView.annotations)
    }
    
    @IBAction func btnFindMe(sender: UIButton) {
        centerMapOnLocation(center!)
    }
    
    @IBAction func mpType(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            mpView.mapType = MKMapType.Satellite
            break
        case 1:
            mpView.mapType = MKMapType.Standard
        default:
            mpView.mapType = MKMapType.Hybrid
        }
    }
    
    @IBAction func zoomSlider(sender: UISlider) {
        delta = sender.value
        centerMapOnLocation(center!)
    }
    
    @IBAction func addRegion(sender: AnyObject) {
        let addRegionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddRegionViewController") as! AddRegionViewController
        addRegionViewController.delegate = self
        self.navigationController?.pushViewController(addRegionViewController, animated: true)
    }
}

