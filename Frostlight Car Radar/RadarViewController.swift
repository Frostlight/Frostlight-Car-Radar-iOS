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

// MARK: - Extensions
// Credits to Fabrizio Bartolomucci @ Stack Overflow
public extension CLLocation {
    func DegreesToRadians(_ degrees: Double ) -> Double {
        return degrees * .pi / 180
    }
    
    func RadiansToDegrees(_ radians: Double) -> Double {
        return radians * 180 / .pi
    }
    
    func bearingToLocationRadian(_ destinationLocation: CLLocation) -> Double {
        let latitude1 = DegreesToRadians(self.coordinate.latitude)
        let longitude1 = DegreesToRadians(self.coordinate.longitude)
        
        let latitude2 = DegreesToRadians(destinationLocation.coordinate.latitude);
        let longitude2 = DegreesToRadians(destinationLocation.coordinate.longitude);
        
        let diffLongitude = longitude2 - longitude1
        
        let y = sin(diffLongitude) * cos(latitude2);
        let x = cos(latitude1) * sin(latitude2) - sin(latitude1) * cos(latitude2) * cos(diffLongitude);
        let radiansBearing = atan2(y, x)
        
        return radiansBearing
    }
    
    func bearingToLocationDegrees(destinationLocation: CLLocation) -> Double{
        return   RadiansToDegrees(bearingToLocationRadian(destinationLocation))
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}

class RadarViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: - Properties
    // Outlets
    @IBOutlet weak var compassImageView: UIImageView! // Image of "compass"
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // Local Properties
    var locationManager: CLLocationManager!
    var userLocation: CLLocation! // Current Location of user
    var savedLocation: CLLocation! // Saved location
    var distanceToLocation: CLLocationDistance! // Distance from user to location
    var mapViewController: MapViewController! // Reference to the map ViewController
    
    // Computed Properties
    var locationBearing: CGFloat {
        return CGFloat(userLocation.bearingToLocationRadian(self.savedLocation)) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tap gesture to resign first responder (hide keyboard)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        view.addGestureRecognizer(tapGesture)

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
            distanceLabel.text = "Initializing"
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    // Update current location on map when location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        userLocation = location
        
        // Update map on MapViewController
        if mapViewController.isViewLoaded {
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapViewController.map.setRegion(region, animated: true)
        }
        
        // TODO: Calculate distance and direction from current location to marked location
        if savedLocation != nil {
            distanceToLocation = savedLocation.distance(from: userLocation)

            if (distanceToLocation > Utility.distanceThreshold) {
                distanceLabel.text = String(format: "%.2f m", distanceToLocation)
            // Too close, reset compass position and set text
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.compassImageView.transform = CGAffineTransform(rotationAngle: 0)
                }
                distanceLabel.text = "At Location"
            }
        }
    }
    
    // Update compass image to match the new heading
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // Computes angle between current location bearing and target location
        func computeAngle(newAngle: CGFloat) -> CGFloat {
            return self.locationBearing - newAngle.degreesToRadians
        }
        
        // Rotate the compass image accordingly
        if self.savedLocation != nil && distanceToLocation != nil && distanceToLocation > Utility.distanceThreshold {
            UIView.animate(withDuration: 0.5) {
                self.compassImageView.transform = CGAffineTransform(rotationAngle: computeAngle(newAngle: CGFloat(newHeading.trueHeading)))
            }
        }
    }
    
    // MARK: - Gestures
    @objc func tap(gesture: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    // MARK: - Actions
    // Save user's current location
    @IBAction func parkHereButton(_ sender: UIBarButtonItem) {
        if #available(iOS 10.0, *) {
            os_log("Park here button pressed.", type: .default)
        }
        
        // Save as local variable and to file
        savedLocation = userLocation
        
        // Save to file
        saveLocationToFile()
        //savedLocationLabel.text = "Latitude: \(savedLocation.latitude), Longitude: \(savedLocation.longitude)"
        
        // Set savedLocationAnnotation in MapView and mark current location on map
        if mapViewController.isViewLoaded {
            mapViewController.savedLocationAnnotation.coordinate = savedLocation.coordinate
            mapViewController.map.addAnnotation(mapViewController.savedLocationAnnotation)
        }
    }
    
    // Clear user's current location
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        if #available(iOS 10.0, *) {
            os_log("Clear button pressed.", type: .default)
        }
        
        // Remove annotation from map (if it exists)
        if mapViewController.isViewLoaded {
            mapViewController.map.removeAnnotation(mapViewController.savedLocationAnnotation)
        }
            
        // Remove local saved location
        savedLocation = nil
        
        // Delete file
        deleteLocationFromFile()
        //savedLocationLabel.text = "Location: Unknown"
        distanceLabel.text = "Not Parked"
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
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userLocation, toFile: Utility.ActiveLocationArchiveURL.path)
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

