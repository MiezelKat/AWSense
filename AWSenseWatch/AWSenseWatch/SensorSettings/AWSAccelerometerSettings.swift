//
//  AWSAccelerometerSettings.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation

public class AWSAccelerometerSettings : AWSSensorSettings {
    
    let updateInterval : TimeInterval
    
    init(updateInterval : TimeInterval) {
        self.updateInterval = updateInterval
    }
    
    override init(){
        updateInterval = 0.1
    }
}
