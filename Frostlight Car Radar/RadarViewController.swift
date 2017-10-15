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

class RadarViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
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
        
        // For UITextFieldDelegate
        textField.delegate = self

        // Set up the reference to mapViewController
        let mapNavigationController = self.tabBarController?.viewControllers?[1] as! UINavigationController
        mapViewController = mapNavigationController.topViewController as! MapViewController
        
        // Set up MapViewController as a CLLocationManager delegate
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
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
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if #available(iOS 10.0, *) {
            os_log("Text field ended editing.", type: .default)
        }
        
        // TODO: Save text to file
        
        // Set textfield in MapViewController to show the same thing
        if mapViewController.isViewLoaded {
            mapViewController.textField.text = textField.text
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
        Utility.saveLocationToFile(location: userLocation)
        
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
        
        // Delete file and update radar label
        Utility.deleteLocationFromFile()
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
}

