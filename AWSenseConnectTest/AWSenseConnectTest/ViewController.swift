//
//  ViewController.swift
//  AWSenseConnectTest
//
//  Created by Katrin Haensel on 22/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startSensingButtonDown(_ sender: Any) {
        var healthStore = HKHealthStore()
        var workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        workoutConfiguration.locationType = .unknown
        print("started workout")
        healthStore.startWatchApp(with: workoutConfiguration) { (success, error) in
            //Some code here
            print(success)
            print(error)
        }
    }
    
    @IBAction func healthKitEnableButtonDown(_ sender: Any) {
        var healthStore = HKHealthStore()
        
        let dataTypes = Set(arrayLiteral: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) {
            success, error in
            // handle the result of the authorization
        }
    }

    @IBAction func motionActivityEnableButton(_ sender: Any) {
        let cmManager = CMMotionActivityManager()
        let queue = OperationQueue()
        cmManager.startActivityUpdates(to: queue, withHandler: { (a : CMMotionActivity?) -> Void in
            cmManager.stopActivityUpdates()
        })
    }
    
}

