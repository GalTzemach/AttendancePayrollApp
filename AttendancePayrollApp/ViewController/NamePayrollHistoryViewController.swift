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

class NamePayrollHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SendDataBackDelegate {
   
    var dateArr = [String]()
    var dayArr = [String]()
    var userName = ""

    var uid = ""
    var currentIndex = -1
    var unconfirmedMode = false
    
    @IBOutlet weak var tableView: UITableView!
    
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: SendDataBackDelegate? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "paycheckCell")
        cell.textLabel?.text = dateArr[indexPath.row]
        cell.textLabel?.textAlignment = NSTextAlignment.center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.dataIsReady(info: "delete")
        
        currentIndex = indexPath.row
        getPaycheckDetails()
        
    }
    
    func dataIsReady(info: String) {
        dateArr.remove(at: currentIndex)
        
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromNamePayrollToDatePaycheckSegue") {
            let destinationVc = segue.destination as! DatePaycheckViewController
            destinationVc.date = dateArr[currentIndex]
            destinationVc.unconfirmedMode = unconfirmedMode
            destinationVc.dayArr = dayArr
            destinationVc.uid = uid
            destinationVc.delegate = self
        }
    }
    
    func getPaycheckDetails() {
        let db = Firestore.firestore()
        dayArr = [String]()
        
        self.view.makeToastActivity(.center)
        
        db.collection("workers/\(uid)/paychecks/\(dateArr[currentIndex])/days").getDocuments { (docs, err) in
            
            self.view.hideToastActivity()
            
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
                    
                    var start: Date = Date()
                    var end: Date = Date()
                    
                    for l in d.data(){
                        if l.key == "start"{
                            start = l.value as! Date
                        }
                        if l.key == "end"{
                            end = l.value as! Date
                        }
                    }
                    var tempDay = d.documentID + "/"
                    
                    let calendar = Calendar.current
                    var components = calendar.dateComponents([.hour, .minute, .second, .month], from: start)
                    
                    tempDay += String(describing: components.month!) + "   "
                    
                    var hour =  components.hour
                    var minute = components.minute
                    var second = components.second
                    tempDay += String(describing: hour!) + ":" + String(describing: minute!) + ":" + String(describing: second!)
                    
                    components = calendar.dateComponents([.hour, .minute, .second], from: end)
                    hour =  components.hour
                    minute = components.minute
                    second = components.second
                    tempDay += " - " + String(describing: hour!) + ":" + String(describing: minute!) + ":" + String(describing: second!)

                    
                    self.dayArr.append(tempDay)
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
        
        let name = userName == "" ? "" : userName + " - "
        self.title = name + "Paychecks"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
