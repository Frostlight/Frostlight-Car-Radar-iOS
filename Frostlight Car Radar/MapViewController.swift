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
    //MARK: - Properties
    @IBOutlet weak var map: MKMapView!
    var savedLocationAnnotation: MKPointAnnotation!
    
    // Reference to the map ViewController
    var radarViewController: RadarViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the reference to radarViewController
        let radarNavigationController = self.tabBarController?.viewControllers?[0] as! UINavigationController
        radarViewController = radarNavigationController.topViewController as! RadarViewController
        
        // Set up saved annotation
        savedLocationAnnotation = MKPointAnnotation()
        savedLocationAnnotation.title = "Parked Location"
        
        // Load saved location and mark annotation if it exists
        if let location = Utility.loadLocationFromFile() {
            savedLocationAnnotation.coordinate = location
            map.addAnnotation(savedLocationAnnotation)
        }
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
