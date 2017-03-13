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
    
    private let bufferLimit = 400//1024
    
    // MARK: - properties
    
    var sensingSession : SensingSession
    
    var sensingBuffers : [AWSSensorType : [AWSSensorData?]]
    var sensingBufferBatchNo : [AWSSensorType : Int]
    var sensingBufferCounter : [AWSSensorType : Int]
    var sensingBufferEvent : SensingBufferEvent = SensingBufferEvent()
    
    let writeQueue = DispatchQueue(label: "write")
    
    // MARK: - init
    
    init(withSession session : SensingSession){
        sensingSession = session
        sensingBuffers = [AWSSensorType : [AWSSensorData]]()
        sensingBufferBatchNo = [AWSSensorType : Int]()
        sensingBufferCounter = [AWSSensorType : Int]()
        for s : AWSSensorType in sensingSession.sensorConfig.enabledSensors{
            sensingBuffers[s] = [AWSSensorData?](repeating: nil, count: bufferLimit)
            sensingBufferBatchNo[s] = 1
            sensingBufferCounter[s] = 0
        }
    }
    
    
    // MARK: - methods
    
    func append(sensingData data: AWSSensorData, forType type: AWSSensorType){
        let count = sensingBufferCounter[type]!
        sensingBuffers[type]![count] = data
        sensingBufferCounter[type] = count + 1
        print("elements: \(count)")
        if(count >= (bufferLimit-1)){
            //queue.async {
                print("full buffer \(type)")
                self.sensingBufferEvent.raiseEvent(withType: .bufferLimitReached, forSensor: type)
            //}
        }
    }
    
//    func copyAndClear(forType type : AWSSensorType) -> [AWSSensorData]{
//        let copy = sensingBuffers[type]
//        sensingBuffers[type]!.removeAll()
//        return copy
//    }
    
    func prepareFileToSend(forType type: AWSSensorType){ // -> (URL, Int){
        let batchNo = sensingBufferBatchNo[type]!
        //let url = 
        serialise(forType: type, batchNo: batchNo)
        // reset the buffer
//        sync (array: sensingBuffers[type]!) {
            sensingBufferCounter[type]! = 0
        
        // sensingBuffers[type]!.removeAll(keepingCapacity: true)
        
//        }
        sensingBufferBatchNo[type] = sensingBufferBatchNo[type]! + 1
       // return (url!, batchNo)
    }

//    private func sync(array: [AWSSensorData], closure: () -> Void) {
//        objc_sync_enter(array)
//        closure()
//        objc_sync_exit(array)
//    }
    
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
