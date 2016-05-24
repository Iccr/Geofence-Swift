    //
//  AddRegionViewController.swift
//  Geofencing
//
//  Created by shishir sapkota on 5/23/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

import UIKit
import MapKit
    
    
    
    struct PolyRegion {
        var title = String()
        var vertices = [CLLocationCoordinate2D]()
        mutating func addVertice(vertice: CLLocationCoordinate2D){
            self.vertices.append(vertice)
        }
    }
    
    protocol RegionDelegate {
        func userdidAddRegion(region:PolyRegion)
    }

class AddRegionViewController: UIViewController, RegionNameDelegate {
    var pointArray: Array<CLLocationCoordinate2D> = []
    
    @IBOutlet weak var mpView: MKMapView!
   
     
    
    var delegate:RegionDelegate? = nil
    
    var polyRegion = PolyRegion()
    var annotationTitle: String?
        override func viewDidLoad() {
        super.viewDidLoad()

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
        print("added location: \(locationCordinate)")
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCordinate
        self.mpView.addAnnotation(annotation)
        }
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

