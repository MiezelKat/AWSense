//
//  SensorConfiguration.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 22/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation

public protocol SensorSettings{
    
    static var sensorType : AWSSensorType {
        get
    }

    var sensorType : AWSSensorType {
        get
    }
    
    static var standardSettings : SensorSettings{
        get
    }
}
