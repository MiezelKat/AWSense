//
//  HeartRateSensorSettings.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 22/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation

public struct HeartRateSensorSettings : SensorSettings{
    
    public static let sensorType : AWSSensorType = AWSSensorType.heart_rate
    
    public var sensorType : AWSSensorType{
        return type(of: self).sensorType
    }
    
    public static var standardSettings : SensorSettings = HeartRateSensorSettings()
    
    public init(){
    }
    
}
