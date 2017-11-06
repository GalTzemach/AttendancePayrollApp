//
//  Worker.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 05/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit

class Worker: NSObject {

    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var paymentPerHour: Float
    var isStaticLocation: Bool
    
    init(email: String, password: String, firstName: String, lastName: String, paymentPerHour: Float, isStaticLocation: Bool) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.paymentPerHour = paymentPerHour
        self.isStaticLocation = isStaticLocation
    }
    
    func show() {
        print("Worker [email = \(email), password = \(password), firstName = \(firstName), lastName = \(lastName), paymentPerHour = \(paymentPerHour), isStaticLocation = \(isStaticLocation)]")
    }
    
    
}
