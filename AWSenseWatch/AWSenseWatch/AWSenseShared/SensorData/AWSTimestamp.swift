//
//  AWSTimestamp.swift
//  AWSense
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation


public class AWSTimestamp : NSObject{
    
    private static var _lastWatchBoot : Date?
    
    static var lastWatchBoot : Date{
        get{
            if(_lastWatchBoot == nil){
                // now since boot
                let uptime = ProcessInfo.processInfo.systemUptime
                // Now since 1970
                let nowTimeIntervalSince1970 = Date().timeIntervalSince1970;
                
                // offset from 1970
                let offset = nowTimeIntervalSince1970 - uptime;
                _lastWatchBoot = Date(timeIntervalSince1970: offset)
            }
            return _lastWatchBoot!
        }
    }
    
    public private(set) var date : Date
    
    public private(set) var ti : TimeInterval
    
    public var data : [AnyObject] {
        get{
            return [date as AnyObject,
                ti as AnyObject] as [AnyObject]
        }
    }

    
    override init(){
        date = Date()
        ti = date.timeIntervalSince(AWSTimestamp.lastWatchBoot)
    }
    
    public init(date: Date, ti : TimeInterval){
        self.date = date
        self.ti = ti
    }
    
    public init(ti : TimeInterval){
        self.date = Date(timeInterval: ti, since: AWSTimestamp.lastWatchBoot as Date)
        self.ti = ti
    }
    
    public init(date : Date){
        self.date = date
        self.ti = date.timeIntervalSince(AWSTimestamp.lastWatchBoot)
    }
    
    public init(data : [AnyObject]){
        date = data[0] as! Date
        ti = data[1] as! TimeInterval
    }
    
    
    
}
