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
import os.log

class RadarViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: - Properties
    // Outlets
    @IBOutlet weak var compassImageView: UIImageView! // Image of "compass"
    
    // Local Properties
    var locationManager: CLLocationManager!
    var userCoordinate: CLLocationCoordinate2D! // Current Location of user
    var savedLocation: CLLocationCoordinate2D! // Saved location
    var mapViewController: MapViewController! // Reference to the map ViewController
    
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
        
        // Load saved location
        if let location = Utility.loadLocationFromFile() {
            savedLocation = location
            //savedLocationLabel.text = "Latitude: \(savedLocation.latitude), Longitude: \(savedLocation.longitude)"
        }
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
        
        // TODO: Calculate distance and direction from current location to marked location
        
        
    }
    
    // Update compass image to match the new heading
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // Rotate the compass image accordingly
        UIView.animate(withDuration: 0.5) {
            let angle = newHeading.trueHeading
            let radians = CGFloat(-angle / 180.0 * .pi)
            self.compassImageView.transform = CGAffineTransform(rotationAngle: radians)
        }

    }
    
    // MARK: - Actions
    /*@IBAction func updateLocationButton(_ sender: UIButton) {
        currentLocationLabel.text = "Latitude: \(userCoordinate.latitude), Longtiude: \(userCoordinate.longitude)"
    }*/
    
    // Save user's current location
    @IBAction func parkHereButton(_ sender: UIBarButtonItem) {
        if #available(iOS 10.0, *) {
            os_log("Park here button pressed.", type: .default)
        }
        
        // Save as local variable and to file
        savedLocation = userCoordinate
        
        // Save to file
        saveLocationToFile()
        //savedLocationLabel.text = "Latitude: \(savedLocation.latitude), Longitude: \(savedLocation.longitude)"
        
        // Set savedLocationAnnotation in MapView and mark current location on map
        if mapViewController.isViewLoaded {
            mapViewController.savedLocationAnnotation.coordinate = savedLocation
            mapViewController.map.addAnnotation(mapViewController.savedLocationAnnotation)
        }
    }
    
    // Clear user's current location
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        if #available(iOS 10.0, *) {
            os_log("Clear button pressed.", type: .default)
        }
        
        // Remove annotation from map
        mapViewController.map.removeAnnotation(mapViewController.savedLocationAnnotation)
        
        // Remove local saved location
        savedLocation = nil
        
        // Delete file
        deleteLocationFromFile()
        //savedLocationLabel.text = "Location: Unknown"
    }
    
    // TODO: Backup user's current saved location into a saved list
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if #available(iOS 10.0, *) {
            os_log("Save button pressed.", type: .default)
        }
        
    }
    
    // TODO: Restore one of the saved locations onto the view
    @IBAction func loadButton(_ sender: UIBarButtonItem) {
        if #available(iOS 10.0, *) {
            os_log("Load button pressed.", type: .default)
        }
    }
    
    // MARK: - Private Functions
    // Save the current location into file
    private func saveLocationToFile() {
        // Switch to CLLocation format for encoding
        let location = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(location, toFile: Utility.ActiveLocationArchiveURL.path)
        if #available(iOS 10.0, *) {
            if isSuccessfulSave {
                os_log("Successfully saved location.", type: .default)
            } else {
                os_log("Failed to save location.", type: .default)
            }
        }
        
    }
    
    // Deletes the location file
    private func deleteLocationFromFile() {
        // Create a FileManager instance
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: Utility.ActiveLocationArchiveURL.path)
        } catch {
            if #available(iOS 10.0, *) {
                os_log("Failed to clear location.", type: .default)
            }
        }
    }
}

