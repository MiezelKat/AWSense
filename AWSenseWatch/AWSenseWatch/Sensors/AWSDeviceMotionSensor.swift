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

class AWSDeviceMotionSensor : AWSSensor{
    
    static let sensorSingleton = AWSDeviceMotionSensor()
    
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
        return motionManager.isDeviceMotionAvailable
    }
    
    func isRegistered() -> Bool{
        return true
        //TODO:
    }
    
    func isSensing() -> Bool{
        return motionManager.isDeviceMotionActive
    }
    
    func startSensing(){
        
        if (motionManager.isDeviceMotionAvailable == true) {
            
            let handler:CMDeviceMotionHandler = {(data: CMDeviceMotion?, error: Error?) -> Void in
                if(data != nil ){
                    // TODO: Evaluate
                    
                    /*
                     rotation Optional(__C.CMRotationRate(x: -0.0039372127503156662, y: 0.0018090186640620232, z: -0.00074236281216144562))
                     gravity Optional(__C.CMAcceleration(x: -0.011102629825472832, y: 0.35229679942131042, z: -0.93582242727279663))
                     accel Optional(__C.CMAcceleration(x: 0.00087199360132217407, y: 0.0042889714241027832, z: -0.010448873043060303))
                     magnetic field Optional(__C.CMCalibratedMagneticField(field: __C.CMMagneticField(x: 0.0, y: 0.0, z: 0.0), accuracy: __C.CMMagneticFieldCalibrationAccuracy))
                     attitude Optional(CMAttitude Pitch: -20.676964, Roll: -0.671815, Yaw: -46.549194
                     )
 */
                    print("attitude \(data?.attitude)")
                    print("rotation \(data?.rotationRate)")
                    print("gravity \(data?.gravity)")
                    print("accel \(data?.userAcceleration)")
                    print("magnetic field \(data?.magneticField)")
                    
                    //self.event.raise(data: AWSGyroscopeSensorData(timestamp : AWSTimestamp(ti: (data?.timestamp)!), rotationRate : (data?.rotationRate)!))
                }
                else{
                    print("no gyroscope data")
                }
            }
            
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: handler)
        }
    }
    
    func stopSensing(){
        motionManager.stopDeviceMotionUpdates()
    }
    
}
