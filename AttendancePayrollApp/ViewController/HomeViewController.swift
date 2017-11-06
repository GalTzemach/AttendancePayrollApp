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
        emailField.text? = "talzemah1@gmail.com"
        passwordField.text? = "123456"
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
//            if signIn() {
//                // Sign in success.
//                if isWorker() {
//                    // Worker mode
//                    let WorkerMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "WorkerMenuVC") as! WorkerMenuViewController
//                    navigationController?.pushViewController(WorkerMenuVC,animated: true)
//
//                } else {
//                    // Employer mode
//                    let EmployerMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "EmployerMenuVC") as! EmployerMenuViewController
//                    navigationController?.pushViewController(EmployerMenuVC,animated: true)
//                }
//            } else {
//                // Sign in failed.
//                self.view.makeToast("Sign in failed, try again!", duration: 1.5, position: .center)
//            }
        }
    }
    
    func clearAllFields() {
        emailField.text?.removeAll()
        passwordField.text?.removeAll()
    }
    
    func signIn() {
        clearAllFields()
        self.view.makeToastActivity(.center)

        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if user != nil
            {
                // Sign in success
                ///self.view.hideToastActivity()
                print("SUCCESSFUL sign in")
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
                self.view.makeToast("Sign in failed, try again!", duration: 1.5, position: .center)
            }
        })
    }
    
    func isWorkerOrEmployer() {
        
        ///db
        self.view.hideToastActivity()

        // Worker mode
        let WorkerMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "WorkerMenuVC") as! WorkerMenuViewController
        navigationController?.pushViewController(WorkerMenuVC,animated: true)
        
   
        // Employer mode
//        let EmployerMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "EmployerMenuVC") as! EmployerMenuViewController
//        navigationController?.pushViewController(EmployerMenuVC,animated: true)
    }
    
    
    
}
