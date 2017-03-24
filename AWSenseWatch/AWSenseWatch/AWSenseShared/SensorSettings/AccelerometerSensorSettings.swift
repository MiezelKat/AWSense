//
//  RawAccelerometerSensorSettings.swift
//  AWSenseWatch
//
//  Created by Katrin Hansel on 10/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation

public struct RawAccelerometerSensorSettings : SensorSettings{
    
    public static let sensorType : AWSSensorType = AWSSensorType.accelerometer
    
    public var sensorType : AWSSensorType{
        return type(of: self).sensorType
    }
    
    public static var standardSettings : SensorSettings = RawAccelerometerSensorSettings()
    
    internal static let defaultUpdateIntervall = 50.0
    
    public var updateIntervall : Double{
        didSet {
            if(updateIntervall <= 0 || updateIntervall > 100){
                print("accelerometer update intervall out of range: \(updateIntervall)")
                updateIntervall = RawAccelerometerSensorSettings.defaultUpdateIntervall
            }
        }
    }
    
    public init(){
        updateIntervall = RawAccelerometerSensorSettings.defaultUpdateIntervall
    }
    
    public init(withIntervall intervall: Double){
        updateIntervall = intervall
    }

}
