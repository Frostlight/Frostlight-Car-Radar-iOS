//
//  MapViewController.swift
//  Frostlight Car Radar
//
//  Created by Vincent on 9/7/17.
//  Copyright © 2017 Frostlight. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    //MARK: - Properties
    @IBOutlet weak var map: MKMapView!
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
        let region = MKCoordinateRegion(center: userCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.map.setRegion(region, animated: true)
    }

}
