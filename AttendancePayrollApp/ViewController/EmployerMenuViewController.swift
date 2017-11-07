//
//  EmployerMenuViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EmployerMenuViewController: UIViewController {

    var uidArr = [String]()
    var nameArr = [String]()
    
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
            let destVC = segue.destination as! PayrollHistoryViewController
            destVC.unconfirmedMode = unconfirmedMode ? true : false
            destVC.payrollArr = nameArr
            destVC.uidArr = uidArr
        }
    }
    
    func getAllPayrollHistoryFromDB(isClose: Bool) {
        
        let db = Firestore.firestore()
        
        uidArr = [String]()
        nameArr = [String]()
        
        self.view.makeToastActivity(.center)
        
        // Retrieve all the names of employees who have a closed paycheck/s
        
        // Get all workers
        db.collection("workers").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                self.view.hideToastActivity()
                self.view.makeToast("Getting document workers failed", duration: 1.5, position: .center)
            }
            
            else {
                var uidCounter = querySnapshot?.count
                
                if uidCounter == 0 {
                    self.view.hideToastActivity()
                    self.view.makeToast("There is no data to show", duration: 1.5, position: .center)
                }
                
                for document in querySnapshot!.documents {
                    // Check each worker if he has a closed paycheck
                    db.collection("workers/\(document.documentID)/paychecks").whereField("isClose", isEqualTo: isClose).getDocuments(completion: { (querySnapshot, err) in
                        
                        if let err = err {
                            print("Error getting documents: \(err)")
                            self.view.hideToastActivity()
                            self.view.makeToast("Getting document workers failed", duration: 1.5, position: .center)
                        }
                        
                        else {
                            
                            if (querySnapshot?.documents.count)! > 0 {
                                // Add uid to the set
                                //uidSet.insert(document.documentID)
                                self.uidArr.append(document.documentID)
                            }
                        }
                        // Ensure the completion of all asynchronous iterations
                        uidCounter! -= 1
                        if uidCounter == 0{
                            
                            // Get a name for each uid from the set
                            var counter =  self.uidArr.count
                            if counter > 0 {
                            for UID in self.uidArr{
                                db.collection("allUsers").document("\(UID)").getDocument(completion: { (querySnapshot, err) in
                                   
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                        self.view.hideToastActivity()
                                        self.view.makeToast("Getting document workers failed", duration: 1.5, position: .center)
                                    }
                                    
                                    else {
                                        
                                        var first = ""
                                        var last = ""
                                        
                                        for element in (querySnapshot?.data())!{
                                            
                                            if element.key == "firstName"{
                                                first = element.value as! String
                                            }
                                            if element.key == "lastName"{
                                                last = element.value as! String
                                            }
                                            
                                            if first != "" && last != ""{
                                                self.nameArr.append("\(first) \(last)")
                                                break
                                            }
                                        }
                                    }
                                    counter = counter - 1
                                    if counter == 0{
                                        // Get all data success.
                                        self.view.hideToastActivity()
                                        self.performSegue(withIdentifier: "fromEmployerMenuToPayrollHistorySegue", sender: self)

                                    }
                                })
                            }
                            }
                            else{
                                self.view.hideToastActivity()
                                self.view.makeToast("There is no data to show", duration: 1.5, position: .center)
                            }
                        }
                    })
                }
            }
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
        getAllPayrollHistoryFromDB(isClose: true)
    }
    
    @IBAction func UnconfirmedPayrollClicked(_ sender: Any) {
        unconfirmedMode = true
        getAllPayrollHistoryFromDB(isClose: false)

        ///performSegue(withIdentifier: "fromEmployerMenuToPayrollHistorySegue", sender: self)
    }
    

}
