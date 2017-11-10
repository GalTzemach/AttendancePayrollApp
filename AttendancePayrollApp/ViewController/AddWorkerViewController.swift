//
//  AddWorkerViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddWorkerViewController: UIViewController {

    // Outlets.
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var paymentPerHourField: UITextField!
    @IBOutlet weak var isStaticLocationField: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Actions - (buttons clicked)
    @IBAction func createWorkerClicked(_ sender: Any) {
        if anyFieldIsEmpty() {
            self.view.makeToast("There is empty field/s", duration: 1.5, position: .center)
            
        } else {
            let tempWoeker = Worker.init(email: emailField.text!, password: passwordField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, paymentPerHour: Float(paymentPerHourField.text!)!, isStaticLocation: isStaticLocationField.isOn)
            addWorker(worker: tempWoeker)
        }
    }
    
    func anyFieldIsEmpty() -> Bool {
        return (emailField.text!.isEmpty || passwordField.text!.isEmpty || firstNameField.text!.isEmpty || lastNameField.text!.isEmpty || paymentPerHourField.text!.isEmpty);
    }
    
    func addWorker(worker: Worker) {
        self.view.makeToastActivity(.center)
        let db = Firestore.firestore()
        let employerUid = Auth.auth().currentUser?.uid
        
        // Create new worker to DB.
        Auth.auth().createUser(withEmail: worker.email, password: worker.password, completion: { (user, error) in
            if user != nil
            {
                db.collection("allUsers").document(employerUid!).getDocument(completion: { (doc, err) in
                    
                    if let err = err {
                        print(err.localizedDescription)
                        self.view.hideToastActivity()
                        self.view.makeToast("Add worker failed, try again!", duration: 1.5, position: .center)
                        
                    }
                    else{
                        for pair in (doc?.data())! {
                            if pair.key == "businessId"{
                                let bid = pair.value
                                
                                // Add new worker to allUsers
                                db.document("allUsers/" + (user?.uid)!).setData(["businessId" : bid, "isEmployer" : false,  "email" : worker.email, "firstName" : worker.firstName, "lastName" : worker.lastName, "paymentPerHour" : worker.paymentPerHour, "isStaticLocation" : worker.isStaticLocation], options: SetOptions.merge(), completion: { (error) in
                                    
                                    if let err = error {
                                        print(err.localizedDescription)
                                        self.view.hideToastActivity()
                                        self.view.makeToast("Add worker failed, try again!", duration: 1.5, position: .center)
                                        
                                    } else{
                                        // Create new documet for the new worker
                                        db.collection("workers").document((user?.uid)!).setData(["createdAt" : FieldValue.serverTimestamp()], completion: { (error) in
                                            
                                            self.view.hideToastActivity()

                                            if let err = error {
                                                print(err.localizedDescription)
                                                self.view.makeToast("Add worker failed, try again!", duration: 1.5, position: .center)
                                                
                                            } else {
                                                // Add worker success.
                                            }
                                            self.signInAgain()
                                        })
                                    }
                                })
                                break
                            }
                        }
                    }
                })
            } else {
                // Could not create new user
            
                if let myEror = error?.localizedDescription
                {
                    print(myEror)
                }
                
                // Add user for worker failed.
                self.view.hideToastActivity()
                self.view.makeToast("Worker already exist, try again!", duration: 1.5, position: .center)
            }
        })
    }
    
    func signInAgain(){
        
        // Signin admin again
        let defaults = UserDefaults.standard
        let pass = defaults.object(forKey: "EmployerPass") as? String ?? ""
        
        Auth.auth().signIn(withEmail: "talzemah1@gmail.com", password: pass, completion: { (user, error) in
            
            self.view.hideToastActivity()

            if user != nil
            {
                // Sign in sucessful
                // Eventually Add worker success.
                self.navigationController?.popViewController(animated: true)
                
            }
            else
            {
                if let myEror = error?.localizedDescription
                {
                    print(myEror)
                }
                self.view.makeToast("Sign in failed, try again!", duration: 1.5, position: .center)
            }
        })
    }
   
    
}
