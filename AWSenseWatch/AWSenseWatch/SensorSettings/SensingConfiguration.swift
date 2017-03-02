//
//  SensingConfiguration.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 02/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation

public class SensingConfiguration{
    
    public var enabledSensors : Set<AWSSensorType> = Set<AWSSensorType>()
    
    func enableSensor(withType type : AWSSensorType){
        enabledSensors.insert(type)
    }
 
    func disableSensor(withType type : AWSSensorType){
        enabledSensors.remove(type)
    }
}
