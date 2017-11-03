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
    static let ActiveLocationArchiveURL = DocumentsDirectory.appendingPathComponent("activeLocation") // Currently active location
    static let TextFieldArchiveURL = DocumentsDirectory.appendingPathComponent("textField") // Text field save location
    static let ImperialFlagArchiveURL = DocumentsDirectory.appendingPathComponent("imperial") // Units save location
    
    // AdMob Application ID
    static let AdsApplicationID = "ca-app-pub-8451127810761579~2824172456"
    
    // AdMob Ad IDs (Implementation)
    static let AdsRadarAdID = "ca-app-pub-8451127810761579/4296325789"
    static let AdsMapAdID = "ca-app-pub-8451127810761579/8036260246"
    
    // AdMob Ad IDs (For testing only)
    //static let AdsRadarAdID = "ca-app-pub-3940256099942544/6300978111"
    //static let AdsMapAdID = "ca-app-pub-3940256099942544/6300978111"
    
    // Threshold for radar to indicate "too close" (in metres)
    static let distanceThreshold: CLLocationDistance = 15.0
    
    // MARK: - Check GPS
    // Checks if GPS is active and functional or not
    static func checkGPS() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        }
        return false
    }
    
    // MARK: - Location Save/Load
    // Save a location to file
    static func saveLocationToFile(location: CLLocation!) {
        NSKeyedArchiver.archiveRootObject(location, toFile: ActiveLocationArchiveURL.path)
    }
    
    // Load a location from file
    static func loadLocationFromFile() -> CLLocation? {
        let location = NSKeyedUnarchiver.unarchiveObject(withFile: ActiveLocationArchiveURL.path) as? CLLocation
        return location
    }
    
    // Delete the location file
    static func deleteLocationFromFile() {
        // Create a FileManager instance
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: ActiveLocationArchiveURL.path)
        } catch {
            if #available(iOS 10.0, *) {
                os_log("Failed to clear location.", type: .default)
            }
        }
    }
    
    // MARK: - TextField Save/Load
    // Save textfield contents to file
    static func saveTextToFile(text: String!) {
        NSKeyedArchiver.archiveRootObject(text, toFile: TextFieldArchiveURL.path)
    }
    
    // Load textfield contents from file
    static func loadTextFromFile() -> String! {
        let text = NSKeyedUnarchiver.unarchiveObject(withFile: TextFieldArchiveURL.path) as? String
        return text
    }
    
    // Delete textfield contents file
    static func deleteTextFromFile() {
        // Create a FileManager instance
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: TextFieldArchiveURL.path)
        } catch {
            if #available(iOS 10.0, *) {
                os_log("Failed to clear location.", type: .default)
            }
        }
    }
    
    // MARK: - Imperial Flag Save/Load
    // If true, use imperial units (feet)
    static func saveImperial(imperial: Bool!) {
        NSKeyedArchiver.archiveRootObject(imperial, toFile: ImperialFlagArchiveURL.path)
    }
    
    // Load imperial flag from file
    static func loadImperial() -> Bool! {
        let imperial = NSKeyedUnarchiver.unarchiveObject(withFile: ImperialFlagArchiveURL.path) as? Bool
        return imperial
    }
}
