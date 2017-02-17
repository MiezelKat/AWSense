//
//  InterfaceController.swift
//  AWSSenseTest WatchKit Extension
//
//  Created by Katrin Haensel on 16/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import WatchKit
import Foundation
import AWSenseWatch


class InterfaceController: WKInterfaceController, AWSSensorEventHandler {

    @IBOutlet var accelXLabel: WKInterfaceLabel!
    
    @IBOutlet var accelAvailableLabel: WKInterfaceLabel!
    @IBOutlet var gyroAvailableLabel: WKInterfaceLabel!
    @IBOutlet var magnetAvailableLabel: WKInterfaceLabel!
    @IBOutlet var deviceMotionAvailableLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let aws = AWSSensorManager.sharedInstance
        
        gyroAvailableLabel.setText("\(aws.isSensorAvailable(sensor: AWSSensorType.gyroscope))")
        magnetAvailableLabel.setText("\(aws.isSensorAvailable(sensor: AWSSensorType.magnetometer))")
        deviceMotionAvailableLabel.setText("\(aws.isSensorAvailable(sensor: AWSSensorType.device_motion))")
        
        // accelerometer events
        
        if(aws.isSensorAvailable(sensor: AWSSensorType.accelerometer)){
            aws.register(eventhandler: self, with: AWSSensorType.accelerometer)
            aws.startSensing(with: AWSSensorType.accelerometer)
        }
        
        if(aws.isSensorAvailable(sensor: AWSSensorType.heart_rate)){
            aws.register(eventhandler: self, with: AWSSensorType.heart_rate)
            aws.startSensing(with: AWSSensorType.heart_rate)
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func handleSensing(data: AWSSensorData, type: AWSSensorType) {
        if(type == AWSSensorType.accelerometer){
            DispatchQueue.main.async {
                self.accelAvailableLabel.setText(data.prettyPrint)
            }
        }else if(type == AWSSensorType.heart_rate){
            DispatchQueue.main.async {
                self.gyroAvailableLabel.setText(data.prettyPrint)
            }
        }
    }

}
