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
    
    // Reference to the map ViewController
    var radarViewController: RadarViewController!
    
    // Location of user
    var userCoordinate: CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the reference to radarViewController
        let radarNavigationController = self.tabBarController?.viewControllers?[0] as! UINavigationController
        radarViewController = radarNavigationController.topViewController as! RadarViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
