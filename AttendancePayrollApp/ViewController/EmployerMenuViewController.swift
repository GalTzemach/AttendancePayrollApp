//
//  EmployerMenuViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmployerMenuViewController: UIViewController {

    var unconfirmedMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable back button from this viewController
        navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromEmployerMenuToPayrollHistorySegue") {
            let destinationVc = segue.destination as! PayrollHistoryViewController
            destinationVc.unconfirmedMode = unconfirmedMode ? true : false
        }
    }
    
    
    // Actions - (buttons clicked)
    @IBAction func logOutClicked(_ sender: Any) {
        self.view.makeToastActivity(.center)
        try! Auth.auth().signOut()
        self.view.hideToastActivity()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payrollHistoryClicked(_ sender: Any) {
        unconfirmedMode = false
        performSegue(withIdentifier: "fromEmployerMenuToPayrollHistorySegue", sender: self)
    }
    
    @IBAction func UnconfirmedPayrollClicked(_ sender: Any) {
        unconfirmedMode = true
        performSegue(withIdentifier: "fromEmployerMenuToPayrollHistorySegue", sender: self)
    }
    

}
