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
import FirebaseAuth
import FirebaseFirestore

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
        emailField.text = "talzemah1@gmail.com"
        passwordField.text = "123456"
        firstNameField.text = "Tal"
        lastNameField.text = "Zemah"
        businessNameField.text = "TalZemahPlace"

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
    
    func registerEmployerToDB(employer: Employer) {
        self.view.makeToastActivity(.center)
        
        Auth.auth().createUser(withEmail: employer.email, password: employer.password, completion: { (user, error) in
            if user != nil
            {
                // Add employer to allUsers
                let db = Firestore.firestore()

                db.document("allUsers/" + (user?.uid)!).setData(["businessId" : employer.businessName, "isEmployer" : true,  "email" : (user?.email)!, "firstName" : employer.businessName, "lastName" : employer.lastName, "location" : ["lati":employer.location.latitude, "long":employer.location.longitude]], options: SetOptions.merge(), completion: { (error) in
                    
                    self.view.hideToastActivity()
                    
                    if let err = error{
                        print(err.localizedDescription)
                        self.view.makeToast("register failed, try again!", duration: 1.5, position: .center)
                        
                    } else {
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                })
            }
            else
            {
                if let myEror = error?.localizedDescription
                {
                    print(myEror)
                }
                self.view.hideToastActivity()
                self.view.makeToast("User already exist, try again!", duration: 1.5, position: .center)

            }
        })
    }
    
    // Actions - (buttons clicked)
    @IBAction func signUpClicked(_ sender: Any) {
        if anyFieldIsEmpty() {
            self.view.makeToast("There is empty field/s", duration: 1.5, position: .center)
            
        } else if businessLocation == nil {
            self.view.makeToast("You must choose business location", duration: 1.5, position: .center)

        } else {
            let tempEmployer = Employer.init(email: emailField.text!, password: passwordField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, businessName: businessNameField.text!, location: businessLocation!)
            
            registerEmployerToDB(employer: tempEmployer)
        }
    }
    
    func anyFieldIsEmpty() -> Bool {
        return (emailField.text!.isEmpty || passwordField.text!.isEmpty || firstNameField.text!.isEmpty || lastNameField.text!.isEmpty || businessNameField.text!.isEmpty);
    }
    

}
