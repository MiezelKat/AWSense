//
//  AWSMagnetometerSensor.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class AWSMagnetometerSensor : AWSSensor{
    
    static let sensorSingleton = AWSMagnetometerSensor()
    
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
        return motionManager.isMagnetometerAvailable
    }
    
    func isRegistered() -> Bool{
        return true
        // TODO:
    }
    
    func isSensing() -> Bool{
        return motionManager.isMagnetometerActive
    }
    
    func startSensing(){
        
        // Get NSTimeInterval of uptime i.e. the delta: now - bootTime
        let uptime = ProcessInfo.processInfo.systemUptime
        
        // Now since 1970
        let nowTimeIntervalSince1970 = NSDate().timeIntervalSince1970;
        
        // Voila our offset
        let offset = nowTimeIntervalSince1970 - uptime;
        
//        if (motionManager.isMagnetometerAvailable == true) {
//            let handler:CMMagnetometerHandler = {(data: CMGyroData?, error: NSError?) -> Void in
//                
//                } as! CMGMagnetometerHandler
//            motionManager.magnetometerUpdateInterval = 0.1
//            motionManager.startMagnetometerUpdates(to: OperationQueue.current!, withHandler: handler)
//        }
    }
    
    func stopSensing(){
        motionManager.stopGyroUpdates()
    }
    
}
