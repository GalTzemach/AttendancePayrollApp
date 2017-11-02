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
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            self.view.makeToastActivity(.center)
            
            if addWorker() {
                // Add worker success.
                self.view.hideToastActivity() /// ?
                self.navigationController?.popViewController(animated: true)
                
            } else {
                // Add worker failed.
                self.view.hideToastActivity()
                self.view.makeToast("Add worker failed, try again!", duration: 1.5, position: .center)
           
            }
        }
    }
    
    func anyFieldIsEmpty() -> Bool {
        return (emailField.text!.isEmpty || passwordField.text!.isEmpty || firstNameField.text!.isEmpty || lastNameField.text!.isEmpty || paymentPerHourField.text!.isEmpty || longitudeField.text!.isEmpty || latitudeField.text!.isEmpty);
    }
    
    func addWorker() -> Bool {
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
