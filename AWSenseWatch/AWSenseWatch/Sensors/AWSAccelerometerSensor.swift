//
//  AWSAccelerometerSensor.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 16/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import AWSenseShared

class AWSAccelerometerSensor : AWSSensor{
    
    static let sensorSingleton = AWSAccelerometerSensor()
    
    static var sensorType : AWSSensorType {
        get{
            return AWSSensorType.accelerometer
        }
    }
    
    private var motionManager : CMMotionManager
    
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
        return motionManager.isAccelerometerAvailable
    }
    
    func isRegistered() -> Bool{
        return true
        // TODO:
    }
    
    func isSensing() -> Bool{
        return motionManager.isAccelerometerActive
    }
    
    func startSensing(){
        if (motionManager.isAccelerometerAvailable == true) {
            
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: Error?) -> Void in
                if(data != nil && data!.timestamp != nil && data?.acceleration != nil){
                    self.event.raise(data: AWSRawAccelerometerSensorData(timestamp : AWSTimestamp(ti: (data?.timestamp)!), acceleration : (data?.acceleration)!))
                }
                else{
                    print("no accelerometer data")
                }
            }
            
            motionManager.accelerometerUpdateInterval = 0.05
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: handler)
        }
    }
    
    func stopSensing(){
        motionManager.stopAccelerometerUpdates()
    }
    
}
