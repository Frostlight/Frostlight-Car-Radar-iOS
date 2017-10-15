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

class MapViewController: UIViewController {
    // MARK: - Properties
    // Outlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var textField: UITextField!
    
    // Local Properties
    var savedLocationAnnotation: MKPointAnnotation!
    var radarViewController: RadarViewController! // Reference to the map ViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tap gesture to resign first responder (hide keyboard)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        // Set up the reference to radarViewController
        let radarNavigationController = self.tabBarController?.viewControllers?[0] as! UINavigationController
        radarViewController = radarNavigationController.topViewController as! RadarViewController
        
        // Set up saved annotation
        savedLocationAnnotation = MKPointAnnotation()
        savedLocationAnnotation.title = "Parked Location"
        
        // Load saved location and mark annotation if it exists
        if let location = Utility.loadLocationFromFile() {
            savedLocationAnnotation.coordinate = location.coordinate
            map.addAnnotation(savedLocationAnnotation)
        }
    }
    
    // MARK: - Gestures
    @objc func tap(gesture: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    // MARK: - Actions
    // Just call the corresponding actions on RadarViewController to handle these
    @IBAction func parkHereButton(_ sender: UIBarButtonItem) {
        radarViewController.parkHereButton(sender)
    }
    
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        radarViewController.clearButton(sender)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        radarViewController.saveButton(sender)
    }
    
    @IBAction func loadButton(_ sender: UIBarButtonItem) {
        radarViewController.loadButton(sender)
    }
}
