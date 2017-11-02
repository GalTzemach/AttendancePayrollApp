//
//  PayrollHistoryViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit

class PayrollHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let arr = ["Worker 1", "Worker 2", "Worker 3", "Worker 4", "Worker 5"]
    var currentIndex = -1
    var unconfirmedMode = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "WorkerCell")
        cell.textLabel?.text = arr[indexPath.row]
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
            destinationVc.uid = arr[currentIndex]
            destinationVc.unconfirmedMode = unconfirmedMode
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// print("unconfirmedMode: \(unconfirmedMode)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
