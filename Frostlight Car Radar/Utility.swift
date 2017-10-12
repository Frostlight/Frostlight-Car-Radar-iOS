//
//  Utility.swift
//  Frostlight Car Radar
//
//  Created by Vincent on 9/14/17.
//  Copyright © 2017 Frostlight. All rights reserved.
//

import Foundation
import CoreLocation
import os.log

class Utility {
    
    // MARK: - Constants
    // Directory to save files
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // Currently active location
    static let ActiveLocationArchiveURL = DocumentsDirectory.appendingPathComponent("activeLocation")
    
    // MARK: - Static Functions
    // Initialize location managers used in RadarView and MapView
    static func setUpLocationManager(locationManager: inout CLLocationManager!) {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Load the current tracked location from file
    static func loadLocationFromFile() -> CLLocationCoordinate2D? {
        let location = NSKeyedUnarchiver.unarchiveObject(withFile: ActiveLocationArchiveURL.path) as? CLLocation
        return location?.coordinate
    }
}
