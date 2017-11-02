//
//  NamePayrollHistoryViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit

class NamePayrollHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dateArr = ["10 / 2017", "9 / 2017", "8 / 2017", "7 / 2017", "6 / 2017"]
    var uid = ""
    var currentIndex = -1
    var unconfirmedMode = false

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
        currentIndex = indexPath.row
        performSegue(withIdentifier: "fromNamePayrollToDatePaycheckSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromNamePayrollToDatePaycheckSegue") {
            let destinationVc = segue.destination as! DatePaycheckViewController
            destinationVc.date = dateArr[currentIndex]
            destinationVc.unconfirmedMode = unconfirmedMode
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = uid + " Paychecks"
        // testLabel.text = uid
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
