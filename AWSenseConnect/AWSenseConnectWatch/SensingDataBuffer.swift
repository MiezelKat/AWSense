//
//  SensingDataBuffer.swift
//  AWSenseConnect
//
//  Created by Katrin Hansel on 05/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared

internal class SensingDataBuffer{
    
    private let bufferLimit = 1024
    
    // MARK: - properties
    
    var sensingSession : SensingSession
    
    var sensingBuffers : [AWSSensorType : [AWSSensorData]]
    var sensingBufferBatchNo : [AWSSensorType : Int]
    var sensingBufferEvent : SensingBufferEvent = SensingBufferEvent()
    
    let writeQueue = DispatchQueue(label: "write")
    
    // MARK: - init
    
    init(withSession session : SensingSession){
        sensingSession = session
        sensingBuffers = [AWSSensorType : [AWSSensorData]]()
        sensingBufferBatchNo = [AWSSensorType : Int]()
        for s : AWSSensorType in sensingSession.sensorConfig.enabledSensors{
            sensingBuffers[s] = [AWSSensorData]()
            sensingBufferBatchNo[s] = 1
        }
    }
    
    
    // MARK: - methods
    
    func append(sensingData data: AWSSensorData, forType type: AWSSensorType){
        let count = sensingBuffers[type]!.count
        sensingBuffers[type]!.append(data)
        if(count > (bufferLimit)){
            print("full buffer \(type)")
            self.sensingBufferEvent.raiseEvent(withType: .bufferLimitReached, forSensor: type)
        }
    }
    
    func sendFile(forType type: AWSSensorType){
        let batchNo = sensingBufferBatchNo[type]!
        serialiseAndSend(forType: type, batchNo: batchNo)
        
        sensingBuffers[type]!.removeAll(keepingCapacity: true)
        sensingBufferBatchNo[type] = sensingBufferBatchNo[type]! + 1
    }

    public func subscribe(handler: SensingBufferEventHandler){
        sensingBufferEvent.add(handler: handler)
    }
    
    public func unsubscribe(handler: SensingBufferEventHandler){
        sensingBufferEvent.remove(handler: handler)
    }
}

class SensingBufferEvent{
    
    private var eventHandlers = [SensingBufferEventHandler]()
    
    public func raiseEvent(withType type: SensingBufferEventType, forSensor stype : AWSSensorType) {
        for handler in self.eventHandlers {
            handler.handle(withType: type, forSensor: stype)
        }
    }
    
    public func add(handler: SensingBufferEventHandler){
        eventHandlers.append(handler)
    }
    
    public func remove(handler: SensingBufferEventHandler){
        eventHandlers = eventHandlers.filter { $0 !== handler }
    }
}

protocol SensingBufferEventHandler : class {
    
    func handle(withType type: SensingBufferEventType, forSensor stype: AWSSensorType)
    
}

enum SensingBufferEventType{
    case bufferLimitReached
}
