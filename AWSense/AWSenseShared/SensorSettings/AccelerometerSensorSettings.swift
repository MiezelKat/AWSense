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
    
    public static let defaultUpdateIntervallHz = 50.0
    
    public var updateIntervallHz : Double{
        didSet {
            if(updateIntervallHz <= 0 || updateIntervallHz > 100){
                print("accelerometer update intervall out of range: \(updateIntervallHz)")
                updateIntervallHz = RawAccelerometerSensorSettings.defaultUpdateIntervallHz
            }
        }
    }
    
    public init(){
        updateIntervallHz = RawAccelerometerSensorSettings.defaultUpdateIntervallHz
    }
    
    public init(withIntervall_Hz intervall: Double){
        updateIntervallHz = intervall
    }

}
