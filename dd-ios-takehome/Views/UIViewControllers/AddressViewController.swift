//
//  ViewController.swift
//  dd-ios-takehome
//
//  Created by Christopher Kelley on 10/25/19.
//  Copyright © 2019 Christopher Kelley. All rights reserved.
//

import UIKit
import MapKit

class AddressViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var confirmAddressButton: UIButton!
    
    private let mapRegionRadius: CLLocationDistance = 1000
    private let locationManager = CLLocationManager()
    var isLocationFound = false
    var currentLocation:CLLocation?
    var searchResults: ExploreResultArray?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        addressLabel.text = "Tap To Select Your Location On The Map"
        
        mapView.delegate = self
        setupMapViewGestures()
        getUserLocation()
    }

    func setupMapViewGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddressViewController.goToPointOnMap(gRecognizer:)))
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "showTabBar" {
            
            if let navController = self.navigationController,
                let tabBarController = navController.viewControllers.first(where: { $0 as? FeaturesTabBarController != nil }) as? FeaturesTabBarController {
                tabBarController.searchResults = self.searchResults
            }
            
            guard let vc = segue.destination as? FeaturesTabBarController, let _ = vc.viewControllers?.first as? ExploreTableViewController else {
                assertionFailure("Could not find navigation route to Explore Page")
                return
            }
            
            vc.searchResults = self.searchResults
        }
    }
    
    @objc func goToPointOnMap(gRecognizer: UIGestureRecognizer) {
        
        if gRecognizer.state == .ended {
            let selectedPoint = gRecognizer.location(in: mapView)
            let selectedCoordinate = mapView.convert(selectedPoint, toCoordinateFrom: mapView)

            self.selectPointWithPin(with: selectedCoordinate)
        }
    }
    
    func selectPointWithPin(with coordinates: CLLocationCoordinate2D) {
        // Remove any other pins, and add the newly selected one to the map...
        mapView.annotations.forEach { annotation in
            mapView.removeAnnotation(annotation)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)

        getAddressFromCoordinates(location: coordinates) { (streetAddress, error) in
            
            guard let streetAddress = streetAddress, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            self.addressLabel.text = self.formatStreetAddress(with: streetAddress)
        }
        let latString = String(coordinates.latitude)
        let lngString = String(coordinates.longitude)
        
        DashApiManager.instance.searchExploreItems(lat: latString, lng: lngString) { [weak self] (ExploreResultArray, Error) in
           guard let self = self, let result = ExploreResultArray else {
                return
            }
            self.searchResults = result
        }
        
    }
    
    func formatStreetAddress(with placeMark:CLPlacemark) -> String {
        var address = ""

        if let street1 = placeMark.subThoroughfare {
            address += street1 + " "
        }

        if let street2 = placeMark.thoroughfare {
            address += street2
        }

        return address
    }
    
    func getUserLocation() {
               
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func getAddressFromCoordinates(location: CLLocationCoordinate2D, completionHandler:@escaping (_ result: CLPlacemark?, _ error: Error?) -> Void){
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let coder = CLGeocoder()
        
        coder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil, let places = placemarks, !places.isEmpty else {
                return
            }
            completionHandler(places.first, error) //Here error should be nil, per our guard.
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: "" ) as? MKPinAnnotationView
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
        }

        pin?.annotation = annotation

        return pin
    }
    
    
    /**
    - Location Manager Delegation:
    */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        } else if status == .denied {
            self.handleNotAuthorizedError()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !isLocationFound else {
            return
        }

        manager.stopUpdatingLocation()
        self.isLocationFound = true

        if let location = locations.last {
            self.currentLocation = location

            let mapRegion = MKCoordinateRegion(center: location.coordinate,
                                               latitudinalMeters: self.mapRegionRadius,
                                               longitudinalMeters: self.mapRegionRadius)
            self.mapView.setRegion(mapRegion, animated: true)
            self.selectPointWithPin(with: location.coordinate)
        } else {
            self.handleNotAuthorizedError()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let failAlert = UIAlertController(title: "Location Search Failed", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        
        self.present(failAlert, animated: true, completion: nil)
    }
    
    func handleNotAuthorizedError() {
        let locationAlert = UIAlertController(title: "Location Permission Required",
                                      message: "This app requires location permission in order to automatically find the best resturants around you.",
                                      preferredStyle: .actionSheet)

        let sureAction = UIAlertAction(title: "Sure", style: .default) { _ in
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(settingsUrl)
        }

        locationAlert.addAction(sureAction)

        self.present(locationAlert, animated: true)
    }
}
