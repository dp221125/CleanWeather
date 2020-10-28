//
//  LocationManager.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/27.
//

import CoreLocation
import Foundation

class LocationManager: NSObject {
	
	private let cllocationManager: CLLocationManager
	
	var isPermerission: ((Bool) -> Void)
//	var location: ((CLLocation) -> Void)? = nil
    var location: ((Result<CLLocation, Error>) -> Void)? = nil
	
	init(notPermissionMessage: @escaping ((Bool) -> Void)) {
		self.cllocationManager = CLLocationManager()
		self.isPermerission = notPermissionMessage
		super.init()
		self.requestPermission()
		self.cllocationManager.delegate = self

	}
	
	func requestPermission() {
		self.cllocationManager.requestWhenInUseAuthorization()
	}
	
	func requestLocation(location: @escaping ((Result<CLLocation, Error>) -> Void)) {
		self.location = location
		self.cllocationManager.requestLocation()
	}
}
extension LocationManager: CLLocationManagerDelegate {
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch manager.accuracyAuthorization {
		case .fullAccuracy, .reducedAccuracy:
			isPermerission(true)
		default:
			isPermerission(false)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let currentLocation = locations.first,
			  let location = self.location else { return }
        location(.success(currentLocation))
	}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        guard let location = self.location else { return }
        location(.failure(error))
    }
}
