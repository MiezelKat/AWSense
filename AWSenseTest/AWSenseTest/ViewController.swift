//
//  ViewController.swift
//  AWSSenseTest
//
//  Created by Katrin Haensel on 16/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var healthStore = HKHealthStore()
        
        let dataTypes = Set(arrayLiteral: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) {
            success, error in
            
            print("ask!")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

