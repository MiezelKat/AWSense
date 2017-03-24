//
//  DeviceMotionSensorSettings.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 21/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation

public struct DeviceMotionSensorSettings : SensorSettings{
    
    public static let sensorType : AWSSensorType = AWSSensorType.device_motion
    
    public var sensorType : AWSSensorType{
        return type(of: self).sensorType
    }
    
    public static var standardSettings : SensorSettings = DeviceMotionSensorSettings()
        
    internal static let defaultUpdateIntervall = 50.0
    
    public var updateIntervall : Double{
        didSet {
            if(updateIntervall <= 0 || updateIntervall > 100){
                print("device motion update intervall out of range: \(updateIntervall)")
                updateIntervall = DeviceMotionSensorSettings.defaultUpdateIntervall
            }
        }
    }
    
    public init(){
        updateIntervall = DeviceMotionSensorSettings.defaultUpdateIntervall
    }
    
    public init(withIntervall intervall: Double){
        updateIntervall = intervall
    }
    
}
