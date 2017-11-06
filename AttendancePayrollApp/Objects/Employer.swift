//
//  Employer.swift
//  AttendancePayrollApp
//
//  Created by Tal Zemah on 05/11/2017.
//  Copyright © 2017 Tal Zemah. All rights reserved.
//

import UIKit
import CoreLocation

class Employer: NSObject {

    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var location: CLLocationCoordinate2D
    
    init(email: String, password: String, firstName: String, lastName: String, location: CLLocationCoordinate2D) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
    }
    
    func show() {
        print("Employer [email = \(email), password = \(password), firstName = \(firstName), lastName = \(lastName), location = \(location)]")
    }
    
    
}
