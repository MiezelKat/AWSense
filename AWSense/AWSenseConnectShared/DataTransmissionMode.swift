//
//  DataTransmissionMode.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 02/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation



public struct DataTransmissionInterval{
    
    public static let standard = DataTransmissionInterval(10)
    
    private let lowerBound = 1.0
    private let upperBound = 30.0
    
    private var _intervallSeconds : Double = 10.0
    
    /// The Interval in Seconds. Lower Bound 1, Upper bound 30
    public var intervallSeconds : Double {
        get{
            return _intervallSeconds
        }
        set (val){
            if(val > lowerBound && val < upperBound){
                _intervallSeconds = val
            }
            
        }
    }
    
    public init(_ interv: Double){
        intervallSeconds = interv
    }
}
