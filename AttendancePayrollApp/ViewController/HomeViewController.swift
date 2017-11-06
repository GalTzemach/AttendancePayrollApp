//
//  HomeViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 31/10/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // Outlets.
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        designField()
        
        /// delete
        emailField.text? = "a"
        passwordField.text? = "a"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func designField() {
//        let borderColor = UIColor.darkGray
//        emailField.layer.borderColor = borderColor.cgColor
//        emailField.layer.borderWidth = 1.5
//        emailField.layer.cornerRadius = 20
    }
    
    // Actions - (buttons clicked)
    @IBAction func signUpClicked(_ sender: Any) {
        clearAllFields()
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        if (emailField.text!.isEmpty || passwordField.text!.isEmpty) {
            self.view.makeToast("There is empty field/s", duration: 1.5, position: .center)

        } else {
            if signIn() {
                // Sign in success.
                if isWorker() {
                    // Worker mode
                    let WorkerMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "WorkerMenuVC") as! WorkerMenuViewController
                    navigationController?.pushViewController(WorkerMenuVC,animated: true)
                    
                } else {
                    // Employer mode
                    let EmployerMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "EmployerMenuVC") as! EmployerMenuViewController
                    navigationController?.pushViewController(EmployerMenuVC,animated: true)
                }
            } else {
                // Sign in failed.
                self.view.makeToast("Sign in failed, try again!", duration: 1.5, position: .center)
            }
        }
    }
    
    func clearAllFields() {
        emailField.text?.removeAll()
        passwordField.text?.removeAll()
    }
    
    func signIn() -> Bool {
        clearAllFields()

        self.view.makeToastActivity(.center)
        /// Try sign in.
        self.view.hideToastActivity()

        return true
    }
    
    func isWorker() -> Bool {
        self.view.makeToastActivity(.center)
        
        self.view.hideToastActivity()
        return true
    }
    
    
}
