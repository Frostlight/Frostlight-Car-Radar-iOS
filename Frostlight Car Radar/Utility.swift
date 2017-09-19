//
//  Utility.swift
//  Frostlight Car Radar
//
//  Created by Vincent on 9/14/17.
//  Copyright © 2017 Frostlight. All rights reserved.
//

import Foundation
import CoreLocation

class Utility {
    
    // Initialize location managers used in RadarView and MapView
    static func setUpLocationManager(locationManager: inout CLLocationManager!) {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Update location when location changes
}
