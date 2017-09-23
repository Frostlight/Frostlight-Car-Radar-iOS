//
//  Location.swift
//  Frostlight Car Radar
//
//  Created by Vincent on 9/22/17.
//  Copyright © 2017 Frostlight. All rights reserved.
//

import UIKit
import CoreLocation
import os.log

class Locations: NSObject {
    
    
    
    // Location of user
    var userCoordinate: CLLocationCoordinate2D!
    
    // MARK: - Initialization
    init?(location: CLLocationCoordinate2D) {
        self.userCoordinate = location
    }
}
