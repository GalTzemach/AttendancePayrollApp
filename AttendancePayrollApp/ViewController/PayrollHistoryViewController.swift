//
//  PayrollHistoryViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PayrollHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SendDataBackDelegate{
    
    var payrollArr = [String]()
    var uidArr = [String]()
    var dateArr = [String]()
    var currentIndex = -1
    var unconfirmedMode = false
    
    @IBOutlet weak var tableView: UITableView!
    
    
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
        getPaychecks(isClose: !unconfirmedMode)
    }
    
    func dataIsReady(info: String) {
        payrollArr.remove(at: currentIndex)
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromPayrollToWorkerPayrollSegue") {
            let destinationVc = segue.destination as! NamePayrollHistoryViewController
            destinationVc.unconfirmedMode = unconfirmedMode
            destinationVc.uid = uidArr[currentIndex]
            destinationVc.dateArr = dateArr
            destinationVc.userName = payrollArr[currentIndex]
            destinationVc.delegate = self
        }
    }
    
    
    func getPaychecks(isClose: Bool) {
        let db = Firestore.firestore()
        dateArr = [String]()
        
        self.view.makeToastActivity(.center)
        db.collection("workers/\(uidArr[currentIndex])/paychecks").whereField("isClose", isEqualTo: isClose).getDocuments { (docs, err) in
            
            self.view.hideToastActivity()
            if let err = err {
                print("Error getting documents: \(err)")
            }
            
            else {
                var docsCounter = docs?.count
                
                for doc in (docs?.documents)!{
                    docsCounter = docsCounter! - 1
                    self.dateArr.append(doc.documentID)
                    
                    if docsCounter == 0 {
                        
                        self.performSegue(withIdentifier: "fromPayrollToWorkerPayrollSegue", sender: self)
                    }
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
