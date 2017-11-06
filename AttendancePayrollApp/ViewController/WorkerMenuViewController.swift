//
//  WorkerMenuViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import CoreLocation

class WorkerMenuViewController: UIViewController, CLLocationManagerDelegate {

    let MAX_HOUR_SHIFT = 8
    var isStartBtn = true
    
    // For timer using.
    var timer = Timer()
    var time = 0
    
    // For location using.
    let locationManager = CLLocationManager()
    var userLocation: CLLocation = CLLocation(latitude: 0, longitude: 0) // Default location.
    
    // Outlets
    @IBOutlet weak var StartStopBtn: UIButton!
    @IBOutlet weak var timerLbl: UILabel!
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        userLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        /// print(userLocation.coordinate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable back button from this viewController
        navigationItem.hidesBackButton = true

        // Show appropriate button
        isStartBtn = isStsrtBtn()
        
        if isStartBtn {
            StartStopBtn.setTitle("Start", for: .normal)
            StartStopBtn.backgroundColor = UIColor.green
        } else {
            StartStopBtn.setTitle("Stop", for: .normal)
            StartStopBtn.backgroundColor = UIColor.red
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isStsrtBtn() -> Bool {
        self.view.makeToastActivity(.center)
        /// Get is start info from DB.
        self.view.hideToastActivity()
        return true
    }
    @objc func increaseTimer() {
        time += 1
        updateTimerOnScreen()

        // after 8 hour stop shift automaticly.
        if time >= 60 * 60 * MAX_HOUR_SHIFT { // sec * min * hour
            StartStopBtn.sendActions(for: .touchUpInside)
        }
    }
    
    func updateTimerOnScreen() {
        let seconds = time % 60
        let s = seconds < 10 ? "0" : ""
        let minutes = (time / 60) % 60
        let m = minutes < 10 ? "0" : ""
        let hour = (time / 3600) % 24
        let h = hour < 10 ? "0" : ""
        timerLbl.text =  h + String(hour) + ":" + m + String(minutes) + ":" + s + String(seconds)
    }
    
    func workplaceIsCorrect() -> Bool {
        self.view.makeToastActivity(.center)
        var isCorrect = false
    
        let distnce = userLocation.distance(from: getWorkplaceLocation())
        /// print("Distance = \(distnce)")
        
        if distnce < 100 {
            isCorrect = true
        }
        
        self.view.hideToastActivity()
        return isCorrect
    }
    
    func getWorkplaceLocation() -> CLLocation {
        /// Get WorkPlace location from DB.
        
        // Apple campus location
        let WorkplaceLatitude = 37.331811
        let WorkplaceLongitude = -122.031201
        let workplaceLocation:CLLocation = CLLocation(latitude: WorkplaceLatitude, longitude: WorkplaceLongitude)

        return workplaceLocation
    }
    
    func insertStartTimeToDB() -> Bool {
        /// date & time.
        let date = Date()
        let calendar = Calendar.current
        
        // Date
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        //Time
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)

        print("\(day)/\(month)/\(year)  \(hour):\(minute):\(second)")

        /// insert to DB
        return true
    }
    
    // Actions - (buttons clicked)
    @IBAction func logOutClicked(_ sender: Any) {
        self.view.makeToastActivity(.center)
        /// call logOut func.
        self.view.hideToastActivity()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startStopClicked(_ sender: Any) {
        if isStartBtn {
            if workplaceIsCorrect() {
                // Change button state.
                StartStopBtn.setTitle("Stop", for: .normal)
                StartStopBtn.backgroundColor = UIColor.red
                isStartBtn = false
                
                // Start timer
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.increaseTimer), userInfo: nil, repeats: true)
                
                /// print(insertStartTimeToDB())
            } else {
                self.view.makeToast("You must be in your workplace location to start a shift", duration: 2, position: .center)
            }
            
        } else {
            // Change button state.
            StartStopBtn.setTitle("Start", for: .normal)
            StartStopBtn.backgroundColor = UIColor.green
            isStartBtn = true
            
            // Stop timer
            timer.invalidate()
            time = 0
            updateTimerOnScreen()
        }
    }
    
}
