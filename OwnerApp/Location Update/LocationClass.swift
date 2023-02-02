//
//  LocationClass.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.
//

//
//  LocationClass.swift
//  FacilityPersonnelApp
//
//  Created by Jailove Mewara on 01/09/21.

import CoreLocation
import UIKit
import GoogleMaps
import GooglePlaces

protocol PrLocation {
    func GetLocation(currentLocation: CLLocationCoordinate2D)
}

class LocationManagerSingleton: NSObject, CLLocationManagerDelegate {
    static let shared: LocationManagerSingleton = .init()

    public lazy var locationManager: CLLocationManager = .init()

    var delegate: PrLocation?

    private var _currentLocation: CLLocation = .init(latitude: 0, longitude: 0)

    var currentLocation: CLLocation {
        return _currentLocation
    }

    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }

    // MARK: - Location Manager Delegate Methods

    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("Location When in use, Successfull--------------------->")
            locationManager.startUpdatingLocation()
        } else if status == .authorizedAlways {
            print("Location Authorized, Successfull--------------------->")
            locationManager.startUpdatingLocation()
        } else if status == .denied {
            appDelegate.RedirectToLocation()
            locationManager.startUpdatingLocation()
            print("Location Denied, Please Check--------------------->")
        } else if status == .notDetermined {
            locationManager.delegate = self
            print("Location Not Determind, Please Check--------------------->")
            locationManager.stopUpdatingLocation()
        } else if status == .restricted {
            print("Location Restricted, Please Check--------------------->")
            appDelegate.RedirectToLocation()
        } else {
            appDelegate.RedirectToLocation()
            print("Location Status Missing, Please Check--------------------->")
        }
    }

    // MARK: - Current location

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            _currentLocation = location

            let cordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

            delegate?.GetLocation(currentLocation: cordinate)
            appDelegate.Lat = "\(location.coordinate.latitude.cleanValuee)"
            appDelegate.Long = "\(location.coordinate.longitude.cleanValuee)"
            self.getAddressFromLatLon(pdblLatitude: appDelegate.Lat, pdblLongitude: appDelegate.Long)

//            let geocoder = CLGeocoder()
//            geocoder.reverseGeocodeLocation(location) { placemarks, error in
//                if error != nil {
//                    print("error in reverseGeocode")
//                }
//                if placemarks != nil {
//                    let placemark = placemarks!
//                    if placemark.count > 0 {
//                        let placemark = placemarks![0]
////                        print(placemark.locality!)
////                        print(placemark.administrativeArea!)
////                        print(placemark.country!)
////
////                        print("Location Address------->", placemark)
////                        print("Location Lattitude and Longitude------->", "\(location.coordinate.latitude) ****** \(location.coordinate.longitude)")
//
//                        self.locationManager.stopUpdatingLocation()
//
//                        appDelegate.Location = "\(placemark.subLocality ?? "") \(placemark.locality ?? "") \(placemark.administrativeArea ?? "") \(placemark.thoroughfare ?? "") \(placemark.name ?? "") \(placemark.country ?? "") \(placemark.postalCode ?? "")"
//                    }
//                }
//            }
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) {
        let geocoder = GMSGeocoder()
        let lat: Double = Double("\(pdblLatitude)")!
                //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
                //72.833770
        let loc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:lat, longitude:lon)
        
        geocoder.reverseGeocodeCoordinate(loc) { response, _ in
            guard
                let address = response?.firstResult(),
                let lines = address.lines
            else {
                return
            }
            self.locationManager.stopUpdatingLocation()
            appDelegate.Location = lines.first ?? appDelegate.Location
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // check  location permissions
            self.checkLocationPermission()
        }
    }

    func checkLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager().authorizationStatus {
            case .notDetermined, .restricted, .denied:
                // open setting app when location services are disabled
                appDelegate.openSettingApp(message: "Location services are not enabled")
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                print(locationManager.location?.coordinate as Any)
            @unknown default:
                return
            }
        } else {
            appDelegate.openSettingApp(message: "Location services are not enabled")
        }
    }

    // MARK: - Start/Stop Updating Location

    func StartStopUpdatingLocation(start: Bool) {
        if start {
            print("Location Updating Start<--------->")
            locationManager.startUpdatingLocation()
            print(locationManager.location?.coordinate as Any)
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
}


extension Double {
    /* Return clean double decimal value */
    var cleanValuee: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.7f", self) : String(format: "%.7f", self)
    }
}
