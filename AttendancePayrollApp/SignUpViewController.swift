//
//  SignUpViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 31/10/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import Toast_Swift

class SignUpViewController: UIViewController {

    // Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var businessNameField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Actions - (buttons clicked)
    @IBAction func signUpClicked(_ sender: Any) {
        if (emailField.text!.isEmpty || passwordField.text!.isEmpty || firstNameField.text!.isEmpty || lastNameField.text!.isEmpty || businessNameField.text!.isEmpty) {
            
            // There is empty field/s.
            self.view.makeToast("There is empty field/s", duration: 1.5, position: .center)
            
        } else {
            // All fields are not empty.
            self.view.makeToastActivity(.center)
            
            if (signUp(email: emailField.text!, pass: passwordField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, businessName: businessNameField.text!)) {
                
                // SignUp success.
                self.view.hideToastActivity()
                self.view.makeToast("Register success", duration: 1.5, position: .center) ///
                self.navigationController?.popViewController(animated: true)

            } else {
                // SignUp failed.
                self.view.hideToastActivity()
                self.view.makeToast("Register failed, try again..")
            }
        }
    }
    
    func signUp(email: String, pass: String, firstName: String, lastName: String, businessName: String) -> Bool {
        return true;
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
