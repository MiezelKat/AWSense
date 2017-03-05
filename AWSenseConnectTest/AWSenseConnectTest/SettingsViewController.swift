//
//  SettingsViewController.swift
//  AWSenseConnectTest
//
//  Created by Katrin Hansel on 04/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import HealthKit
import UIKit

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func healthKitButton(_ sender: Any){

        var healthStore = HKHealthStore()
        
        let dataTypes = Set(arrayLiteral: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) {
            success, error in
            // handle the result of the authorization
        }
    }

    
}

