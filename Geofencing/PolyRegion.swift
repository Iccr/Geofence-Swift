//
//  PolyRegion.swift
//  Geofencing
//
//  Created by shishir sapkota on 5/25/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

// struct that holds the coortinate of all the annotations placed for the location
import CoreLocation
struct PolyRegion {
    var title = String()
    var description = String()
    var vertices = [CLLocationCoordinate2D]()
    mutating func addVertice(vertice: CLLocationCoordinate2D){
        self.vertices.append(vertice)
    }
    
    func Vertices()-> [CLLocationCoordinate2D] {
        return self.vertices
    }
}
