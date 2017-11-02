//
//  DatePaycheckViewController.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 01/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit

class DatePaycheckViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dayArr = ["01  00:00:00 - 22:22:22", "02  00:00:00 - 11:11:11", "03  00:00:00 - 33:33:33"]
    var date = ""
    var unconfirmedMode = false

    
    // Outlets
    @IBOutlet weak var okBtn: UIButton!
    
    
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

        self.title = date + " Paycheck"
        
        if !unconfirmedMode {
            okBtn.isHidden = true
        }
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
