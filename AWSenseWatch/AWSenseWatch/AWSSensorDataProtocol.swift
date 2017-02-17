//
//  AWSSensorDataProtocol.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation


public protocol AWSSensorData{
    var timestamp : AWSTimestamp { get }
    
    static var csvHeader : String { get }
    var csvString : String { get }
    var prettyPrint : String {get}
    
    var data : [AnyObject] { get }
    
    init(timestamp : AWSTimestamp, data: [AnyObject])
    
}
