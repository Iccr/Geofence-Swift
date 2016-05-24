    //
//  AddRegionViewController.swift
//  Geofencing
//
//  Created by shishir sapkota on 5/23/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

import UIKit
import MapKit

class AddRegionViewController: UIViewController {
    var pointArray: Array<CLLocationCoordinate2D> = []
    
    @IBOutlet weak var mpView: MKMapView!
    
        override func viewDidLoad() {
        super.viewDidLoad()

        let rightBtn = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        
        self.navigationItem.rightBarButtonItem = rightBtn
        
        let saveBtn = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "save")
    
        self.navigationItem.leftBarButtonItem = saveBtn
    }

    
    @IBAction func btnAddPin(sender: UILongPressGestureRecognizer) {
        let location = sender.locationInView(mpView)
        let locationCordinate = self.mpView.convertPoint(location, toCoordinateFromView: self.mpView)
        self.pointArray.append(locationCordinate)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCordinate
        
        annotation.title = "test location"
        self.mpView.addAnnotation(annotation)
    }

    
    func save(){
     print("saving")
        print(pointArray)
    }
    func cancel() {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
   }

