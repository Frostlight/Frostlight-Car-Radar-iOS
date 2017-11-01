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
import os.log

class MapViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    // Outlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var unitsButton: UIBarButtonItem!
    
    // Local Properties
    var savedLocationAnnotation: MKPointAnnotation!
    var radarViewController: RadarViewController! // Reference to the map ViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tap gesture to resign first responder (hide keyboard)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        // For UITextFieldDelegate
        textField.delegate = self
        
        // Set up the reference to radarViewController
        let radarNavigationController = self.tabBarController?.viewControllers?[0] as! UINavigationController
        radarViewController = radarNavigationController.topViewController as! RadarViewController
        
        // Load saved imperial flag toggle (if true, units used is feet)
        if let imperial = Utility.loadImperial() {
            if imperial {
                unitsButton.title = "Feet"
            }
        }
        
        // Set up saved annotation
        savedLocationAnnotation = MKPointAnnotation()
        savedLocationAnnotation.title = "Parked Location"
        
        // Load saved location and mark annotation if it exists
        if let location = Utility.loadLocationFromFile() {
            savedLocationAnnotation.coordinate = location.coordinate
            map.addAnnotation(savedLocationAnnotation)
        }
        
        // Load saved TextField string
        if let text = Utility.loadTextFromFile() {
            textField.text = text
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if #available(iOS 10.0, *) {
            os_log("Text field ended editing.", type: .default)
        }
        
        // Save text to file
        Utility.saveTextToFile(text: textField.text)
        
        // Set textfield in MapViewController to show the same thing
        if radarViewController.isViewLoaded {
            radarViewController.textField.text = textField.text
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
    
    @IBAction func unitsButton(_ sender: UIBarButtonItem) {
        radarViewController.unitsButton(sender)
    }
}
