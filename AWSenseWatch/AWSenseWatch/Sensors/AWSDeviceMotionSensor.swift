//
//  AWSDeviceMotionSensor.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import AWSenseShared

class AWSDeviceMotionSensor : AWSSensor{
    
    static let sensorSingleton = AWSDeviceMotionSensor()
    
    static var sensorType : AWSSensorType {
        get{
            return AWSSensorType.device_motion
        }
    }
    
    var motionManager : CMMotionManager
    
    private var event : AWSSensorEvent = AWSSensorEvent(type: sensorType)
    
    private init(){
        motionManager = CMMotionManager()
    }
    
    func register(eventHander : AWSSensorEventHandler){
        event.add(handler: eventHander)
    }
    
    func deregister(eventHander : AWSSensorEventHandler){
        event.remove(handler: eventHander)
    }
    
    func isAvailable() -> Bool {
        return motionManager.isDeviceMotionAvailable
    }
    
    func isRegistered() -> Bool{
        return true
        //TODO:
    }
    
    func isSensing() -> Bool{
        return motionManager.isDeviceMotionActive
    }
    
    func startSensing(withSettings settings: SensorSettings?){
        
        if (motionManager.isDeviceMotionAvailable == true) {
            
            let set = (settings != nil ? settings : DeviceMotionSensorSettings.standardSettings) as! DeviceMotionSensorSettings
            
            let handler:CMDeviceMotionHandler = {(data: CMDeviceMotion?, error: Error?) -> Void in
                if(data != nil ){
                    
                    self.event.raise(data: AWSDeviceMotionSensorData(timestamp: AWSTimestamp(ti: (data?.timestamp)!), deviceMotion : data!))
                }
                else{
                    print("no devie motion data")
                }
            }
            
            motionManager.deviceMotionUpdateInterval = 1.0/set.updateIntervallHz
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: handler)
        }
    }
    
    func stopSensing(){
        motionManager.stopDeviceMotionUpdates()
    }
    
}
