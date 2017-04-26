//
//  SensorManager.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 16/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation


public class AWSSensorManager : NSObject{
    
    /// singleton instance
    public static let sharedInstance = AWSSensorManager()

    /// private init function
    private override init() {}
    
    
    public func isSensorAvailable(sensor : AWSSensorType) -> Bool{
        let sensor : AWSSensor? = get(sensor: sensor)
        return sensor != nil && sensor!.isAvailable()
    }
    
    public func isSensorRegistered(sensor : AWSSensorType) -> Bool{
        let sensor : AWSSensor? = get(sensor: sensor)
        return sensor != nil && sensor!.isRegistered()
    }
    
    public func isSensorSensing(sensor : AWSSensorType) -> Bool{
        let sensor : AWSSensor? = get(sensor: sensor)
        return sensor != nil && sensor!.isSensing()
    }
    
    public func startSensing(withSensor sensor: AWSSensorType, settings: SensorSettings? = nil) {
        let sensor : AWSSensor? = get(sensor: sensor)
        if(sensor != nil){
            sensor!.startSensing(withSettings: settings)
        }else{
            //TODO: error handling
        }
    }
    
//    public func startSensing(withSensors sensors: Set<AWSSensorType>) {
//        for s in sensors{
//            startSensing(withSensor: s)
//        }
//    }
    
    public func startSensing(withConfiguration config: SensingConfiguration){
        let enabledSensors = config.enabledSensors
        
        for s in enabledSensors{
            let settings = config.sensorSettings[s]
            startSensing(withSensor: s, settings: settings)
        }
    }
    
    public func stopSensing(with sensor: AWSSensorType) {
        let sensor : AWSSensor? = get(sensor: sensor)
        if(sensor != nil){
            sensor!.stopSensing()
        }else{
            //TODO: error handling
        }
    }
    
    public func stopSensing(withSensors sensors: Set<AWSSensorType>) {
        for s in sensors{
            stopSensing(with: s)
        }
    }
    
    public func register(eventhandler : AWSSensorEventHandler, withConfiguration config: SensingConfiguration) {
        for s in config.enabledSensors{
            register(eventhandler: eventhandler, with: s)
        }
    }
    
    public func register(eventhandler : AWSSensorEventHandler, with sensor: AWSSensorType) {
        let sensor : AWSSensor? = get(sensor: sensor)
        if(sensor != nil){
            sensor!.register(eventHander: eventhandler)
        }else{
            //TODO: error handling
        }
    }
    
    public func deregister(eventhandler : AWSSensorEventHandler, withConfiguration config: SensingConfiguration) {
        for s in config.enabledSensors{
            deregister(eventhandler: eventhandler, with: s)
        }
    }
    
    public func deregister(eventhandler : AWSSensorEventHandler, with sensor: AWSSensorType) {
        let sensor : AWSSensor? = get(sensor: sensor)
        if(sensor != nil){
            sensor!.deregister(eventHander: eventhandler)
        }else{
            //TODO: error handling
        }
    }
    
    private func get(sensor: AWSSensorType) -> AWSSensor?{
        switch sensor {
        case .accelerometer:
            return AWSAccelerometerSensor.sensorSingleton
        case .device_motion:
            return AWSDeviceMotionSensor.sensorSingleton
        case .heart_rate:
            return AWSHeartRateSensor.sensorSingleton
        default:
            return nil
        }
    }
}
