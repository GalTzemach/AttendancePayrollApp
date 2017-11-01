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

        print("test")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Actions - (buttons clicked)
    @IBAction func signInClicked(_ sender: Any) {
        if (emailField.text!.isEmpty || passwordField.text!.isEmpty) {
            self.view.makeToast("There is empty field/s", duration: 1.5, position: .center)

        } else {
            self.view.makeToastActivity(.center)
            if 1 + 1 > 1 {
                // Sign in success.
                self.view.hideToastActivity()
                if 1 + 1 > 1 {
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
                self.view.hideToastActivity()
                self.view.makeToast("Sign in failed, try again!", duration: 1.5, position: .center)
                emailField.text?.removeAll()
                passwordField.text?.removeAll()
            
            }
        }
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
