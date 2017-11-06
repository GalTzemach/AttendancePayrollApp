//
//  BusinessLocationViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 05/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// Protocol used for sending data back to sign up view controller.
protocol DataReadyDelegate: class {
    func userChooseBusinessLocation(location: CLLocationCoordinate2D)
}

class BusinessLocationViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {

    // Making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: DataReadyDelegate? = nil
    
    let locationManager = CLLocationManager()
    var businessLocation: CLLocationCoordinate2D? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get current location.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Set gesture recognizer on map.
        let tgr = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHandler))
        tgr.delegate = self
        mapView.addGestureRecognizer(tgr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        // Set region around user location.
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let currentLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegionMake(currentLocation, span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func tapGestureHandler(tgr: UITapGestureRecognizer)
    {
        let touchPoint = tgr.location(in: mapView)
        businessLocation = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // Remove All exist annotations.
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        // Add annotation on map.
        let newAnnotation = MKPointAnnotation()
        newAnnotation.title = "Your business location"
        newAnnotation.coordinate = businessLocation!
        mapView.addAnnotation(newAnnotation)
        
    }
    
    // Actions - (buttons clicked)
    @IBAction func selectLocationClicked(_ sender: Any) {
        if let location = businessLocation {
            // Call this method protocol
            delegate?.userChooseBusinessLocation(location: location)
            self.navigationController?.popViewController(animated: true)

        } else {
            self.view.makeToast("You must choose any location", duration: 1.5, position: .center)
        }
    }
    

}
