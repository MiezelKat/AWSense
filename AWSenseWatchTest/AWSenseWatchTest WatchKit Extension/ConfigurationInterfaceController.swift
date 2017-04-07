//
//  ConfigurationInterfaceController.swift
//  AWSenseWatchTest
//
//  Created by Katrin Hansel on 18/02/2017.
//  Copyright © 2017 QMUL. All rights reserved.
//

import WatchKit
import Foundation
import AWSenseWatch
import AWSenseShared


class ConfigurationInterfaceController: WKInterfaceController {
    

    @IBOutlet var accelerometerSwitch: WKInterfaceSwitch!
    @IBOutlet var deviceMotionSwitch: WKInterfaceSwitch!
    @IBOutlet var heartRateSwitch: WKInterfaceSwitch!
    
    var accelerometerSensingOn = false
    var deviceMotionSensingOn = false
    var heartRateSensingOn = false
    
    
    @IBOutlet var startSensingButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let manager = AWSSensorManager.sharedInstance
        
        accelerometerSwitch.setEnabled(manager.isSensorAvailable(sensor: .accelerometer))
        deviceMotionSwitch.setEnabled(manager.isSensorAvailable(sensor: .device_motion))
        heartRateSwitch.setEnabled(manager.isSensorAvailable(sensor: .heart_rate))
        
        startSensingButton.setEnabled(false)
    }
    
    @IBAction func accelerometerStateChanged(_ value: Bool) {
        accelerometerSensingOn = value
        evaluateStartButtonState()
    }
    
    @IBAction func deviceMotionStateChanged(_ value: Bool) {
        deviceMotionSensingOn = value
        evaluateStartButtonState()
    }

    @IBAction func heartRateStateChanged(_ value: Bool) {
        heartRateSensingOn = value
        evaluateStartButtonState()
    }

    func evaluateStartButtonState(){
        startSensingButton.setEnabled(accelerometerSensingOn || deviceMotionSensingOn || heartRateSensingOn)
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func startSensingButtonAction() {
         self.pushController(withName: "sensingIC", context:
            [AWSSensorType.accelerometer: accelerometerSensingOn,
             AWSSensorType.heart_rate: heartRateSensingOn,
             AWSSensorType.device_motion: deviceMotionSensingOn
             ]
        )
    }
    
}
