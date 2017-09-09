//
//  RadarViewController.swift
//  Frostlight Car Radar
//
//  Created by Vincent on 9/5/17.
//  Copyright © 2017 Frostlight. All rights reserved.
//

import UIKit
import CoreLocation

class RadarViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: - Properties
    @IBOutlet weak var currentLocationLabel: UILabel!
    var locationManager: CLLocationManager!
    
    // Location of user
    var userCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up MapViewController as a CLLocationManager delegate
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CLLocationManagerDelegate
    // Update current location on map when location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        userCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    // MARK: - Actions
    @IBAction func updateLocationButton(_ sender: UIButton) {
        currentLocationLabel.text = "The location has been updated."
    }
}

