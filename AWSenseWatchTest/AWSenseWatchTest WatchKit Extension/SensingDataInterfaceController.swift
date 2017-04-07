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
import AWSenseShared


class SensingDataInterfaceController: WKInterfaceController, AWSSensorEventHandler {
    
    @IBOutlet var accelerometerTextLabel: WKInterfaceLabel!
    @IBOutlet var accelerometerLabel: WKInterfaceLabel!
    
    @IBOutlet var heartRateTextLabel: WKInterfaceLabel!
    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    
    @IBOutlet var deviceMotionTextLabel: WKInterfaceLabel!
    @IBOutlet var deviceMotionLabel: WKInterfaceLabel!
    
    var sensors : [AWSSensorType: Bool]?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        sensors = context as! [AWSSensorType: Bool]
        
        let manager = AWSSensorManager.sharedInstance
        
        if(sensors![.heart_rate]! && manager.isSensorAvailable(sensor: .heart_rate)){
            manager.register(eventhandler: self, with: .heart_rate)
            manager.startSensing(withSensor: .heart_rate)
        }else{
            heartRateLabel.setHidden(true)
            heartRateTextLabel.setHidden(true)
        }
        
        if(sensors![.accelerometer]! && manager.isSensorAvailable(sensor: .accelerometer)){
            manager.register(eventhandler: self, with: .accelerometer)
            manager.startSensing(withSensor: .accelerometer, settings: RawAccelerometerSensorSettings(withIntervall_Hz: 50.0))
        }else{
            accelerometerLabel.setHidden(true)
            accelerometerTextLabel.setHidden(true)
        }
        
        if(sensors![.device_motion]! && manager.isSensorAvailable(sensor: .device_motion)){
            manager.register(eventhandler: self, with: .device_motion)
            manager.startSensing(withSensor: .device_motion, settings: DeviceMotionSensorSettings(withIntervall_Hz: 50.0))
        }else{
            deviceMotionLabel.setHidden(true)
            deviceMotionTextLabel.setHidden(true)
        }
        
    }
    
    override func willActivate() {
        visible = true
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        visible = false
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    var visible : Bool = false
    
    func handleSensing(data: AWSSensorData, type: AWSSensorType) {
        if(visible){
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
    
    override func willDisappear() {
        let manager = AWSSensorManager.sharedInstance
        
        if(sensors![.heart_rate]! && manager.isSensorAvailable(sensor: .heart_rate)){
            manager.stopSensing(with: .heart_rate)
        }
        
        if(sensors![.accelerometer]! && manager.isSensorAvailable(sensor: .accelerometer)){
            manager.stopSensing(with: .accelerometer)
        }
        
        if(sensors![.device_motion]! && manager.isSensorAvailable(sensor: .device_motion)){
            manager.stopSensing(with: .device_motion)
        }
    }
}

