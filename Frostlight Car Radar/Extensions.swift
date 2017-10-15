//
//  File.swift
//  Frostlight Car Radar
//
//  Created by Vincent on 10/15/17.
//  Copyright © 2017 Frostlight. All rights reserved.
//

import UIKit
import CoreLocation

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

public extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
