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
        
    internal static let defaultUpdateIntervallHz = 50.0
    
    public var updateIntervallHz : Double{
        didSet {
            if(updateIntervallHz <= 0 || updateIntervallHz > 100){
                print("device motion update intervall out of range: \(updateIntervallHz)")
                updateIntervallHz = DeviceMotionSensorSettings.defaultUpdateIntervallHz
            }
        }
    }
    
    public init(){
        updateIntervallHz = DeviceMotionSensorSettings.defaultUpdateIntervallHz
    }
    
    public init(withIntervall_Hz intervall: Double){
        updateIntervallHz = intervall
    }
    
}
