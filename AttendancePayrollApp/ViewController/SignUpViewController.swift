//
//  SignUpViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 31/10/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import CoreLocation
import Toast_Swift

class SignUpViewController: UIViewController, DataReadyDelegate {
    
    // Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var businessNameField: UITextField!

    var businessLocation: CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// delete
        emailField.text = "a"
        passwordField.text = "a"
        firstNameField.text = "a"
        lastNameField.text = "a"
        businessNameField.text = "a"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromSignUpToBusinessLocationSegue" {
            let businessLocationVC = segue.destination as! BusinessLocationViewController
            businessLocationVC.delegate = self
        }
    }
    
    // Implement protocol method (get data)
    func userChooseBusinessLocation(location: CLLocationCoordinate2D) {
        businessLocation = location
    }
    
    // Actions - (buttons clicked)
    @IBAction func signUpClicked(_ sender: Any) {
        if anyFieldIsEmpty() {
            self.view.makeToast("There is empty field/s", duration: 1.5, position: .center)
            
        } else {
            if signUpEmployer() {
                // SignUp success.
                self.navigationController?.popViewController(animated: true)

            } else {
                // SignUp failed.
                self.view.hideToastActivity()
                self.view.makeToast("Register failed, try again..", duration: 1.5, position: .center)
            }
        }
    }
    
    func anyFieldIsEmpty() -> Bool {
        return (emailField.text!.isEmpty || passwordField.text!.isEmpty || firstNameField.text!.isEmpty || lastNameField.text!.isEmpty || businessNameField.text!.isEmpty || businessLocation == nil);
    }
    
    func signUpEmployer() -> Bool {
        self.view.makeToastActivity(.center)
        
        /// Try sign up.
//        let businessLatitude = 37.331811
//        let businessLongitude = -122.031201
//        let businessLocation:CLLocation = CLLocation(latitude: businessLatitude, longitude: businessLongitude)
        if businessLocation != nil {
            let tempEmployer = Employer.init(email: emailField.text!, password: passwordField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, location: businessLocation!)
            print(tempEmployer.show())
        } else {
            self.view.makeToast("You must choose business location", duration: 1.5, position: .center)
        }
        

        self.view.hideToastActivity()
        return true;
    }

}
