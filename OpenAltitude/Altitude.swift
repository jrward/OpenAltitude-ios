//
//  Altitude.swift
//  OpenAltitude
//
//  Created by Jonathan Ward on 7/8/17.
//  Copyright © 2017 Jonathan Ward. All rights reserved.
//

import Foundation
import CoreLocation

enum AltitudeUnits {
    case meters
    case feet
}

protocol AltitudeDelegate : class {
    func update(altitude: Int, accuracy: Int, units: AltitudeUnits)
}

class Altitude : NSObject, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager!
    static let `default` = Altitude()
    weak var delegate : AltitudeDelegate?

    var units : AltitudeUnits = .meters
    
    
    func start() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
//        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshLocation), userInfo: nil, repeats: true)
    }
    
    func stop() {
        
    }
    
    func changeUnits() {
        switch units {
        case .meters: units = .feet
        case .feet: units = .meters
        }
        
        //get last location and call delegate method to update display immediately
        let lastLocation = locationManager.location ?? CLLocation()
        locationManager(locationManager, didUpdateLocations: [lastLocation])
    }
    
    @objc func refreshLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let altitude = locations.last?.altitude,
            let accuracy = locations.last?.verticalAccuracy {
            
            let convertedAltitude : Int
            let convertedAccuracy : Int
            
            if units == .feet {
                convertedAltitude = Int(round(altitude * 3.28084))
                convertedAccuracy = Int(round(accuracy * 3.28084))
            }
            
            else {
                convertedAltitude = Int(round(altitude))
                convertedAccuracy = Int(round(accuracy))
            }
        
            delegate?.update(altitude: convertedAltitude, accuracy: convertedAccuracy, units: units)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did Fail With Error: \(error.localizedDescription)")
    }
    
    
}
