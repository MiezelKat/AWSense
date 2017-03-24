//
//  AWSSensor.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 16/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared

protocol AWSSensor{
    
    static var sensorType : AWSSensorType { get }
    
    func isAvailable() -> Bool
    func isRegistered() -> Bool
    func isSensing() -> Bool
    
    func startSensing(withSettings: SensorSettings?)
    func stopSensing()
    
    func register(eventHander : AWSSensorEventHandler)
    func deregister(eventHander : AWSSensorEventHandler)
}
