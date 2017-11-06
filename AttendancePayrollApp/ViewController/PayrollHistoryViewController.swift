//
//  PayrollHistoryViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit

class PayrollHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var payrollArr = [String]()
    var currentIndex = -1
    var unconfirmedMode = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payrollArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "WorkerCell")
        cell.textLabel?.text = payrollArr[indexPath.row]
        cell.textLabel?.textAlignment = NSTextAlignment.center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        currentIndex = indexPath.row
        performSegue(withIdentifier: "fromPayrollToWorkerPayrollSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromPayrollToWorkerPayrollSegue") {
            let destinationVc = segue.destination as! NamePayrollHistoryViewController
            destinationVc.uid = payrollArr[currentIndex]
            destinationVc.unconfirmedMode = unconfirmedMode
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if getAllPayrollHistory() {
            print(" ")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllPayrollHistory() -> Bool {
        self.view.makeToastActivity(.center)
        /// get info.
        /// info appropriate to unconfirmed mode.
        payrollArr = ["Worker 1", "Worker 2", "Worker 3", "Worker 4", "Worker 5"]
        self.view.hideToastActivity()
        return true
    }
    
    

}
