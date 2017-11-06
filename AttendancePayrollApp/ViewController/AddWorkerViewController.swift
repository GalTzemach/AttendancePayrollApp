//
//  AddWorkerViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit

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
        emailField.text = "a"
        passwordField.text = "a"
        firstNameField.text = "a"
        lastNameField.text = "a"
        paymentPerHourField.text = "45.5"
        
        print(isStaticLocation.isOn)
        
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
            if addWorker() {
                // Add worker success.
                self.navigationController?.popViewController(animated: true)
                
            } else {
                // Add worker failed.
                self.view.makeToast("Add worker failed, try again!", duration: 1.5, position: .center)
           
            }
        }
    }
    
    func anyFieldIsEmpty() -> Bool {
        return (emailField.text!.isEmpty || passwordField.text!.isEmpty || firstNameField.text!.isEmpty || lastNameField.text!.isEmpty || paymentPerHourField.text!.isEmpty);
    }
    
    func addWorker() -> Bool {
        self.view.makeToastActivity(.center)
        
        /// create new worker to DB.
        let tempWorker = Worker.init(email: emailField.text!, password: passwordField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, paymentPerHour: (paymentPerHourField.text! as NSString).floatValue, isStaticLocation: isStaticLocation.isOn)
        print(tempWorker.show())
        
        self.view.hideToastActivity()
        return true;
    }
    
    
}
