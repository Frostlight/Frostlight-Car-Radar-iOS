//
//  RadarViewController.swift
//  Frostlight Car Radar
//
//  Created by Vincent on 9/5/17.
//  Copyright © 2017 Frostlight. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class RadarViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: - Properties
    @IBOutlet weak var currentLocationLabel: UILabel!
    var locationManager: CLLocationManager!
    
    // Location of user
    var userCoordinate: CLLocationCoordinate2D!
    
    // Reference to the map ViewController
    var mapViewController: MapViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the reference to mapViewController
        let mapNavigationController = self.tabBarController?.viewControllers?[1] as! UINavigationController
        mapViewController = mapNavigationController.topViewController as! MapViewController
        
        // Set up MapViewController as a CLLocationManager delegate
        if (CLLocationManager.locationServicesEnabled()) {
            Utility.setUpLocationManager(locationManager: &locationManager)
            locationManager.delegate = self
        }
        
        // TODO: Load saved location
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
        
        // Update map on MapViewController
        if mapViewController.isViewLoaded {
            let region = MKCoordinateRegion(center: userCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapViewController.map.setRegion(region, animated: true)
        }
    }
    
    // MARK: - Actions
    @IBAction func updateLocationButton(_ sender: UIButton) {
        currentLocationLabel.text = "Latitude: \(userCoordinate.latitude), Longtiude: \(userCoordinate.longitude)"
    }
    
    // TODO: Save user's current location
    @IBAction func parkHereButton(_ sender: UIBarButtonItem) {
        // Save as local variable and to file
    }
    
    // TODO: Clear user's current location
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
    }
    
    // TODO: Backup user's current saved location into a saved list
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
    }
    
    // TODO: Restore one of the saved locations onto the view
    @IBAction func loadButton(_ sender: UIBarButtonItem) {
    }
}

