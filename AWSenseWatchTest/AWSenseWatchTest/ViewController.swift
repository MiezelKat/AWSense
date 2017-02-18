//
//  ViewController.swift
//  AWSenseWatchTest
//
//  Created by Katrin Hansel on 18/02/2017.
//  Copyright © 2017 QMUL. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressHKButton(_ sender: Any) {
        var healthStore = HKHealthStore()
        
        let dataTypes = Set(arrayLiteral: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) {
            success, error in
            // handle the result of the authorisation
        }

    }

}

