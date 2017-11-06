//
//  HomeViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 31/10/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class HomeViewController: UIViewController {
    
    // Outlets.
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// delete
        emailField.text = "gal@gmail.com"
        passwordField.text = "123456"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Actions - (buttons clicked)
    @IBAction func signUpClicked(_ sender: Any) {
        clearAllFields()
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        if (emailField.text!.isEmpty || passwordField.text!.isEmpty) {
            self.view.makeToast("There is empty field/s", duration: 1.5, position: .center)

        } else {
            signIn()
        }
    }
    
    func clearAllFields() {
        emailField.text?.removeAll()
        passwordField.text?.removeAll()
    }
    
    func signIn() {
        self.view.makeToastActivity(.center)

        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if user != nil
            {
                // Sign in success
                self.isWorkerOrEmployer()
                
            }
            else
            {
                if let myEror = error?.localizedDescription
                {
                    print(myEror)
                }
                
                // Sign in failed
                self.view.hideToastActivity()
                self.clearAllFields()
                self.view.makeToast("Sign in failed, try again!", duration: 1.5, position: .center)
            }
        })
    }
    
    func isWorkerOrEmployer() {
        
        let db = Firestore.firestore()

        db.collection("allUsers").document((Auth.auth().currentUser?.uid)!).getDocument { (documentSnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            
            else {
                for elm in documentSnapshot!.data(){
                    if elm.key == "isEmployer"{
                        self.view.hideToastActivity()

                        if elm.value as! Bool == true {
                            // Employer mode.
                            let EmployerMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "EmployerMenuVC") as! EmployerMenuViewController
                            self.navigationController?.pushViewController(EmployerMenuVC,animated: true)
                            
                        } else {
                            // Worker mode.
                            let WorkerMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "WorkerMenuVC") as! WorkerMenuViewController
                            self.navigationController?.pushViewController(WorkerMenuVC,animated: true)
                        }
                        return
                    }
                }
            }
        }
    }
 
    
    
}
