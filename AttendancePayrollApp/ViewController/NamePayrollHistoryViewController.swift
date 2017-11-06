//
//  NamePayrollHistoryViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NamePayrollHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dateArr = ["2017 10", "2017 9", "2017 8", "2017 7", "2017 6"]
    var paycheckArr = [String]()
    var dayArr = [String]()

//    var dayArr = [Dictionary<String, Any>]()
//    var dayArr2 = [Dictionary<String, Dictionary<String, Any>>]()
    
    var uid = ""
    var currentIndex = -1
    var unconfirmedMode = false

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paycheckArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "paycheckCell")
        cell.textLabel?.text = paycheckArr[indexPath.row]
        cell.textLabel?.textAlignment = NSTextAlignment.center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        getPaycheckDetails()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromNamePayrollToDatePaycheckSegue") {
            let destinationVc = segue.destination as! DatePaycheckViewController
            destinationVc.date = paycheckArr[currentIndex]
            destinationVc.unconfirmedMode = unconfirmedMode
            /// destinationVc.dayArr =
        }
    }
    
    func getPaycheckDetails() {
        let db = Firestore.firestore()
        dayArr = [String]()
        
        //// appropriate uid.
        db.collection("workers/\((Auth.auth().currentUser?.uid)!)/paychecks/\(paycheckArr[currentIndex])/days").getDocuments { (docs, err) in
            if let err = err{
                
                print (err.localizedDescription)
                self.view.makeToast("Getting data failed, try again!", duration: 1.5, position: .center)
            }
            else{
                var count = docs?.count
                
                if count == 0 {
                    self.view.makeToast("There is no data to show", duration: 1.5, position: .center)
                }
                
                for d in (docs?.documents)!{
                    
                    var start: String = ""
                    var end: String = ""

                    for l in d.data(){
                        if l.key == "start"{
                            start = l.value as! String
                        }
                        if l.key == "end"{
                            end = l.value as! String
                        }
                        
                    }
                    
                    self.dayArr.append("\(d.documentID) \(start) - \(end)")
                    count = count! - 1
                    
                    if count == 0 {
                        self.performSegue(withIdentifier: "fromNamePayrollToDatePaycheckSegue", sender: self)
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
