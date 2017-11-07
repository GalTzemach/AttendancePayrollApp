//
//  DatePaycheckViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import FirebaseFirestore

// protocol used for sending data back
protocol SendDataBackDelegate: class {
    func dataIsReady(info: String)
}

class DatePaycheckViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: SendDataBackDelegate? = nil
    
    var dayArr = [String]()

    //let dayArr = ["01  00:00:00 - 22:22:22", "02  00:00:00 - 11:11:11", "03  00:00:00 - 33:33:33"]
    
    var uid = ""
    var date = ""
    var unconfirmedMode = false

    
    // Outlets
    @IBOutlet weak var ConfirmPaycheckBtn: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "dayCell")
        cell.textLabel?.text = dayArr[indexPath.row]
        cell.textLabel?.textAlignment = NSTextAlignment.center
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = date + " - Paycheck"
        
        if !unconfirmedMode {
            ConfirmPaycheckBtn.isHidden = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Actions - (buttons clicked)
    @IBAction func confirmPaycheckClicked(_ sender: Any) {
        let db = Firestore.firestore()
        self.view.makeToastActivity(.center)
        // ClosePaycheck
        db.document("workers/" + uid + "/paychecks/\(date)").setData(["isClose" : true], options: SetOptions.merge()) { (error) in
            
            self.view.hideToastActivity()
            
            if let err = error{
                print(err.localizedDescription)
            }
            else{
                print("SUCCESSFUL: closePaycheck")
                
                // call this method on whichever class implements our delegate protocol
                self.delegate?.dataIsReady(info: "delete")
                
                // go back to the previous view controller
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    

    
}
