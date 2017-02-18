//
//  SensingDataInterfaceController.swift
//  AWSenseWatchTest
//
//  Created by Katrin Hansel on 18/02/2017.
//  Copyright © 2017 QMUL. All rights reserved.
//


import WatchKit
import Foundation
import AWSenseWatch


class SensingDataInterfaceController: WKInterfaceController, AWSSensorEventHandler {
    
    @IBOutlet var accelerometerTextLabel: WKInterfaceLabel!
    @IBOutlet var accelerometerLabel: WKInterfaceLabel!
    
    @IBOutlet var heartRateTextLabel: WKInterfaceLabel!
    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    
    @IBOutlet var deviceMotionTextLabel: WKInterfaceLabel!
    @IBOutlet var deviceMotionLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let contextCast = context as! [AWSSensorType: Bool]
        
        let manager = AWSSensorManager.sharedInstance
        
        if(contextCast[.heart_rate]! && manager.isSensorAvailable(sensor: .heart_rate)){
            manager.register(eventhandler: self, with: .heart_rate)
            manager.startSensing(with: .heart_rate)
        }else{
            heartRateLabel.setHidden(true)
            heartRateTextLabel.setHidden(true)
        }
        
        if(contextCast[.accelerometer]! && manager.isSensorAvailable(sensor: .accelerometer)){
            manager.register(eventhandler: self, with: .accelerometer)
            manager.startSensing(with: .accelerometer)
        }else{
            accelerometerLabel.setHidden(true)
            accelerometerTextLabel.setHidden(true)
        }
        
        if(contextCast[.device_motion]! && manager.isSensorAvailable(sensor: .device_motion)){
            manager.register(eventhandler: self, with: .device_motion)
            manager.startSensing(with: .device_motion)
        }else{
            deviceMotionLabel.setHidden(true)
            deviceMotionTextLabel.setHidden(true)
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
                self.accelerometerLabel.setText(data.prettyPrint)
            }
        }else if(type == AWSSensorType.heart_rate){
            DispatchQueue.main.async {
                self.heartRateLabel.setText(data.prettyPrint)
            }
        }else if(type == AWSSensorType.device_motion){
            DispatchQueue.main.async {
                self.deviceMotionLabel.setText(data.prettyPrint)
            }
        }
    }
    
    
}

