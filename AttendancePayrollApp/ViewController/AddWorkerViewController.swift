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
    @IBOutlet weak var isStaticLocation: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// temp
        emailField.text = "gal@gmail.com"
        passwordField.text = "123456"
        firstNameField.text = "Gal"
        lastNameField.text = "Zemah"
        paymentPerHourField.text = "45.5"
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
            addWorker()
        }
    }
    
    func anyFieldIsEmpty() -> Bool {
        return (emailField.text!.isEmpty || passwordField.text!.isEmpty || firstNameField.text!.isEmpty || lastNameField.text!.isEmpty || paymentPerHourField.text!.isEmpty);
    }
    
    func addWorker() {
        self.view.makeToastActivity(.center)
        let db = Firestore.firestore()

//        let tempWorker = Worker.init(email: emailField.text!, password: passwordField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, paymentPerHour: (paymentPerHourField.text! as NSString).floatValue, isStaticLocation: isStaticLocation.isOn)
        ///print(tempWorker.show())
        
        let employerUid = Auth.auth().currentUser?.uid
        
        // Create new worker to DB.
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if user != nil
            {
                print("SUCCESSFUL: New user created")
                
                db.collection("allUsers").document(employerUid!).getDocument(completion: { (doc, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        self.view.hideToastActivity()
                        self.view.makeToast("Add worker failed, try again!", duration: 1.5, position: .center)
                        
                    }
                    else{
                        for d in (doc?.data())! {
                            if d.key == "businessId"{
                                let bid = d.value
                                
                                // Add new worker to allUsers
                                print("uid= ", (user?.uid)!)
                                db.document("allUsers/" + (user?.uid)!).setData(["businessId" : bid, "isEmployer" : false,  "email" : self.emailField.text!, "firstName" : self.firstNameField.text!, "lastName" : self.lastNameField.text!, "paymentPerHour" : self.paymentPerHourField.text!], options: SetOptions.merge(), completion: { (error) in
                                    
                                    if let err = error {
                                        print(err.localizedDescription)
                                        self.view.hideToastActivity()
                                        self.view.makeToast("Add worker failed, try again!", duration: 1.5, position: .center)
                                        
                                    } else{
                                        print("SUCCESSFUL: Add new worker to allUsers")
                                        
                                        // Create new documet for the new worker
                                        db.collection("workers").document((user?.uid)!).setData(["createdAt" : FieldValue.serverTimestamp()], completion: { (error) in
                                            if let err = error {
                                                print(err.localizedDescription)
                                                self.view.hideToastActivity()
                                                self.view.makeToast("Add worker failed, try again!", duration: 1.5, position: .center)
                                                self.signInAgain()
                                                
                                            } else {
                                                print("SUCCESSFUL: Create new documet for the new worker")
                                                self.signInAgain()
                                                
                                            }
                                        })
                                    }
                                })
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
                
                // Add worker failed.
                self.view.hideToastActivity()
                self.view.makeToast("This worker already exist, try again!", duration: 1.5, position: .center)
            }
        })
    }
    
    func signInAgain(){
        
        // Signin admin again
        Auth.auth().signIn(withEmail: "talzemah1@gmail.com", password: "123456", completion: { (user, error) in
            
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
                self.view.makeToast("Add worker failed, try again!", duration: 1.5, position: .center)
            }
        })
    }
    
   
    
}
