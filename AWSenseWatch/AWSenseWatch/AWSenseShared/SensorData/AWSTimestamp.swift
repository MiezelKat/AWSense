//
//  AWSTimestamp.swift
//  AWSense
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation


public class AWSTimestamp : NSObject{
    
    private static var _lastBoot : Date?
    
    static var lastBoot : Date{
        get{
            if(_lastBoot == nil){
                // now since boot
                let uptime = ProcessInfo.processInfo.systemUptime
                // Now since 1970
                let nowTimeIntervalSince1970 = Date().timeIntervalSince1970;
                
                // offset from 1970
                let offset = nowTimeIntervalSince1970 - uptime;
                _lastBoot = Date(timeIntervalSince1970: offset)
            }
            return _lastBoot!
        }
    }
    
    public private(set) var date : Date
    
    public private(set) var ti : TimeInterval
    
    override init(){
        date = Date()
        ti = date.timeIntervalSince(AWSTimestamp.lastBoot)
    }
    
    public init(date: Date, ti : TimeInterval){
        self.date = date
        self.ti = ti
    }
    
    public init(ti : TimeInterval){
        self.date = Date(timeInterval: ti, since: AWSTimestamp.lastBoot as Date)
        self.ti = ti
    }
    
    public init(date : Date){
        self.date = date
        self.ti = date.timeIntervalSince(AWSTimestamp.lastBoot)
    }
    
}
