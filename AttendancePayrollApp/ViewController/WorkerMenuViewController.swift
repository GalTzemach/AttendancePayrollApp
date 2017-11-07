//
//  WorkerMenuViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore

class WorkerMenuViewController: UIViewController, CLLocationManagerDelegate {

    let MAX_HOUR_SHIFT = 8
    var isStartBtn = true
    
    // For timer using.
    var timer = Timer()
    var time = 0
    
    // For location using.
    let locationManager = CLLocationManager()
    var userLocation: CLLocation = CLLocation(latitude: 0, longitude: 0) // Default location.
    
    // Data from DB.
    var paycheckArr = [String]()
    var dayArr = [String]()
    
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

        checkIfIsStsrtBtn()
    }
    
    func showAppropriateButton() {
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
    
    func checkIfIsStsrtBtn() {
        let db = Firestore.firestore()
        self.view.makeToastActivity(.center)
        
        // Get current date
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        let yearMonth: String = "\(year!) "+"\(month!)"
        
        /// Get is start info from DB.
        db.document("workers/\((Auth.auth().currentUser?.uid)!)/paychecks/\(yearMonth)/days/\(day!)").getDocument { (doc, err) in
            
            self.view.hideToastActivity()
            
            if let err = err{
                print (err.localizedDescription)
                self.view.makeToast("Getting data failed", duration: 1.5, position: .center)
            }
            else {
                
                if !(doc?.exists)! {
                    self.isStartBtn = true
                } else if doc?.data() != nil && doc?.data().count == 2{
                    self.isStartBtn = false
                    self.StartStopBtn.isEnabled = false
                } else if doc?.data().count == 1 {
                    self.isStartBtn = false
                }
                
                self.showAppropriateButton()
            }
        }
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
    
    func workplaceIsCorrect() {
        self.view.makeToastActivity(.center)
        let db = Firestore.firestore()
        
        db.document("allUsers/\((Auth.auth().currentUser?.uid)!)").getDocument { (doc, err) in
            
            if let err = err{
                print(err.localizedDescription)
                self.view.makeToast("Getting data failed, try again!", duration: 1.5, position: .center)
            }
            
            else {
                // Change button state.
                self.StartStopBtn.setTitle("Stop", for: .normal)
                self.StartStopBtn.backgroundColor = UIColor.red
                self.isStartBtn = false
                
                // Start timer
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.increaseTimer), userInfo: nil, repeats: true)
                
                // Insert Start time to DB.
                
                // Get current date
                let date = Date()
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day], from: date)
                let year =  components.year
                let month = components.month
                let day = components.day
                
                // Add start day
                db.collection("workers").document((Auth.auth().currentUser?.uid)!).collection("paychecks").document("\(year!) "+"\(month!)").collection("days").document("\(day!)").setData(["start" : FieldValue.serverTimestamp()], options: SetOptions.merge()) { (error) in
                    
                    self.view.hideToastActivity()

                    if let err = error{
                        print(err.localizedDescription)
                    }
                        
                    else{
                        db.collection("workers").document((Auth.auth().currentUser?.uid)!).collection("paychecks").document("\(year!) "+"\(month!)").setData(["isClose": false], completion: { (err) in
                            if let err = err{
                                print(err.localizedDescription)
                            }
                            else{
                                print("okkkkkkkkk")
                                self.view.makeToast("Shift starting...", duration: 1.5, position: .center)
                            }
                        })
                    }
                }
                
            }
            
            

        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromWorkerMenuToNamePayrollHistorySegue" {
            let namePayrollHistoryVC = segue.destination as! NamePayrollHistoryViewController
            namePayrollHistoryVC.uid = (Auth.auth().currentUser?.uid)!
            namePayrollHistoryVC.dateArr = paycheckArr
        }
        
        if segue.identifier == "fromWorkerMenuToDataPaycheckSegue" {
            let destinationVC = segue.destination as! DatePaycheckViewController
            destinationVC.dayArr = dayArr
        }
    }
    
    func getPaychecksArrFromDB(){
        let db = Firestore.firestore()
        var arr = [String]()
        
        self.view.makeToastActivity(.center)
        
        db.collection("workers/\(Auth.auth().currentUser!.uid)/paychecks").whereField("isClose", isEqualTo: true).getDocuments { (querySnapshot, err) in

            self.view.hideToastActivity()

            if let err = err {
                print("Error getting documents: \(err)")
                self.view.makeToast("Getting data failed, try again!", duration: 1.5, position: .center)

            } else {
                var counter = querySnapshot?.count

                if counter == 0 {
                    self.view.makeToast("There is no data to show", duration: 1.5, position: .center)
                }
                
                for doc in (querySnapshot?.documents)!{
                    counter = counter! - 1
                    arr.append(doc.documentID)
                    if counter == 0 {
                        // Data ready to use.
                        self.paycheckArr = arr
                        self.performSegue(withIdentifier: "fromWorkerMenuToNamePayrollHistorySegue", sender: self)
                    }
                }
            }
        }
    }
    
    func getLastPaycheck() {
        
        dayArr = [String]()
        let db = Firestore.firestore()
        self.view.makeToastActivity(.center)
        
        db.collection("workers/\((Auth.auth().currentUser?.uid)!)/paychecks").whereField("isClose", isEqualTo: false).getDocuments { (docs, err) in
            
            if let err = err{
                print(err.localizedDescription)
                self.view.hideToastActivity()
                self.view.makeToast("Getting data failed, try again!", duration: 1.5, position: .center)
            }
            else{
                // Get current date
                let date = Date()
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day], from: date)
                let year =  components.year
                let month = components.month
                let yearMonth: String = "\(year!) " + "\(month!)"
                
                for doc in (docs?.documents)!{
                    if doc.documentID == yearMonth {
                        db.collection("workers/\((Auth.auth().currentUser?.uid)!)/paychecks/\(yearMonth)/days").getDocuments(completion: { (docs, err) in
                            
                            self.view.hideToastActivity()

                            if let err = err {
                                print(err.localizedDescription)
                                self.view.makeToast("Getting data failed, try again!", duration: 1.5, position: .center)

                            }
                            else{
                                var count = docs?.count
                                
                                if count == 0 {
                                    self.view.makeToast("There is no data to show", duration: 1.5, position: .center)
                                }
                                
                                for doc in (docs?.documents)!{
                                    
                                    var start: Date = Date()
                                    var end: Date = Date()
                                    
                                    for l in doc.data(){
                                        if l.key == "start"{
                                            start = l.value as! Date
                                        }
                                        if l.key == "end"{
                                            end = l.value as! Date
                                        }
                                        
                                    }
                                    var tempDay = doc.documentID + "/"
                                    
                                    let calendar = Calendar.current
                                    var components = calendar.dateComponents([.hour, .minute, .second, .month], from: start)
                                    
                                    tempDay += String(describing: components.month!) + "   "
                                    
                                    var hour =  components.hour
                                    var minute = components.minute
                                    var second = components.second
                                    tempDay += String(describing: hour!) + ":" + String(describing: minute!) + ":" + String(describing: second!)
                                    
                                    components = calendar.dateComponents([.hour, .minute, .second], from: end)
                                    hour =  components.hour
                                    minute = components.minute
                                    second = components.second
                                    tempDay += " - " + String(describing: hour!) + ":" + String(describing: minute!) + ":" + String(describing: second!)
                                    
                                    
                                    self.dayArr.append(tempDay)
                                   
                                    count = count! - 1
                                    if count == 0 {

                                        self.performSegue(withIdentifier: "fromWorkerMenuToDataPaycheckSegue", sender: self)
                                    }
                                }
                            }
                        })
                    }
                    break
                }
                self.view.hideToastActivity()
                self.view.makeToast("There is no data to show", duration: 1.5, position: .center)
            }
        }
        
    }
    
    // Actions - (buttons clicked)
    @IBAction func logOutClicked(_ sender: Any) {
        self.view.makeToastActivity(.center)
        try! Auth.auth().signOut()
        self.view.hideToastActivity()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func paycheckHistoryClicked(_ sender: Any) {
        getPaychecksArrFromDB()
    }
    
    @IBAction func currentPaycheckClicked(_ sender: Any) {
        getLastPaycheck()
    }
    
    @IBAction func startStopClicked(_ sender: Any) {
        if isStartBtn {
            
            workplaceIsCorrect()
            
        } else {
            self.view.makeToastActivity(.center)
            let db = Firestore.firestore()
            
            // Stop timer
            timer.invalidate()
            time = 0
            updateTimerOnScreen()
            
            // Get current date
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            let year =  components.year
            let month = components.month
            let day = components.day
            
            // Add end day
            db.collection("workers").document((Auth.auth().currentUser?.uid)!).collection("paychecks").document("\(year!) "+"\(month!)").collection("days").document("\(day!)").setData(["end" : date], options: SetOptions.merge()) { (error) in
                
                self.view.hideToastActivity()
                
                if let err = error{
                    print(err.localizedDescription)
                    self.view.makeToast("Insert data failed, try again!", duration: 1.5, position: .center)
                }
                else{
                    self.view.makeToast("Shift stop..", duration: 1.5, position: .center)
                    self.checkIfIsStsrtBtn()
                }
            }
        }
    }
    
}
