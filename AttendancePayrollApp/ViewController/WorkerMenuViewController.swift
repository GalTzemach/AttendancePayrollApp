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

    var isStartBtn = true
    var timer = Timer()
    var time = 0
    
    let manager = CLLocationManager()
    var userLatitude: Double = 0
    var userLongitude: Double = 0
    
    // Outlets
    @IBOutlet weak var StartStopBtn: UIButton!
    @IBOutlet weak var timerLbl: UILabel!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
        
        /// manager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Show appropriate button
        if isStartBtn {
            StartStopBtn.setTitle("Start", for: .normal)
            StartStopBtn.backgroundColor = UIColor.green
        } else {
            StartStopBtn.setTitle("Stop", for: .normal)
            StartStopBtn.backgroundColor = UIColor.red
        }
        
        // Location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func increaseTimer() {
        time += 1
        updateTimerOnScreen()
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
    
    func isWorkplaceLocation() -> Bool {
        self.view.makeToastActivity(.center)
        var res = false
    
        // Apple campus location
        let WorkPlaceLatitude = 37.331811
        let WorkPlaceLongitude = -122.031201
        
        let userLocation:CLLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
        let workPlaceLocation:CLLocation = CLLocation(latitude: WorkPlaceLatitude, longitude: WorkPlaceLongitude)
        let distnce = userLocation.distance(from: workPlaceLocation)
        print("Distance = \(distnce)")
        
        if distnce < 100 {
            res = true
        }
        
        self.view.hideToastActivity()
        return res
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
            if isWorkplaceLocation() {
                // The workplace location is correct
                StartStopBtn.setTitle("Stop", for: .normal)
                StartStopBtn.backgroundColor = UIColor.red
                isStartBtn = false
                
                // Start timer
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.increaseTimer), userInfo: nil, repeats: true)
            } else {
                self.view.makeToast("You must be in your workplace location to start a shift", duration: 2, position: .center)
            }
            
        } else {
            StartStopBtn.setTitle("Start", for: .normal)
            StartStopBtn.backgroundColor = UIColor.green
            isStartBtn = true
            
            // Stop timer
            timer.invalidate()
            time = 0
            updateTimerOnScreen()
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
