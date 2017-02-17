//
//  AWSGyroscopeSensor.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 16/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class AWSGyroscopeSensor : AWSSensor{
    
    static let sensorSingleton = AWSGyroscopeSensor()
    
    static var sensorType : AWSSensorType {
        get{
            return AWSSensorType.gyroscope
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
        return motionManager.isGyroAvailable
    }
    
    func isRegistered() -> Bool{
        return true
        // TODO:
    }
    
    func isSensing() -> Bool{
        return motionManager.isGyroActive
    }
    
    func startSensing(){
        if (motionManager.isGyroAvailable == true) {
            
            let handler:CMGyroHandler = {(data: CMGyroData?, error: Error?) -> Void in
                if(data != nil && data!.timestamp != nil && data?.rotationRate != nil){
                    self.event.raise(data: AWSGyroscopeSensorData(timestamp : AWSTimestamp(ti: (data?.timestamp)!), rotationRate : (data?.rotationRate)!))
                }
                else{
                    print("no gyroscope data")
                }
            }
            
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: handler)
        }
    }
    
    func stopSensing(){
        motionManager.stopGyroUpdates()
    }
    
}
