//
//  SensingDataManager.swift
//  AWSenseConnect
//
//  Created by Katrin Hansel on 05/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared

internal class SensingDataManager : SensingBufferEventHandler {
    

    // MARK: - singleton
    
    internal static let instance : SensingDataManager = SensingDataManager()
    
    private init(){
        
    }
    
    
    // MARK: - properties

    var sensingDataBuffer : SensingDataBuffer?
    
    var sensingSession : SensingSession? {
        return SensingSessionManager.instance.currentSession
    }
    
    var transmissionIntervall: DataTransmissionInterval?{
        return SensingSessionManager.instance.currentSession?.transmissionIntervall
    }
    
    var lastTransmissions : [AWSSensorType : Date] = [AWSSensorType : Date]()
    
    let writeQueue = DispatchQueue(label: "send")
    
    // MARK: - methods
    
    func initialise(withSession session: SensingSession){
        sensingDataBuffer = SensingDataBuffer(withSession: session)
        
        let now = Date()
        for type in session.sensorConfig.enabledSensors{
            lastTransmissions[type] = now
        }
    }
    
    func manage(sensingData data : AWSSensorData, forType type: AWSSensorType){
        let nextTransmission = lastTransmissions[type]!.addingTimeInterval(transmissionIntervall!.intervallSeconds)
        
        let refDate = Date().addingTimeInterval(-2)
        
        sensingDataBuffer!.append(sensingData: data, forType: type)
        //if(lastTransmissions[type]!.compare(refDate) == .orderedAscending){
        if(nextTransmission.compare(Date()) == .orderedAscending){
            sendData(forType: type)
        }

    }
    
    func sessionStopped(){
        if(sensingDataBuffer != nil){
            for s in sensingSession!.sensorConfig.enabledSensors{
                sendData(forType: s)
            }
        }
    }
    
    // MARK: - SensingBufferEventHandler

    func handle(withType type: SensingBufferEventType, forSensor stype: AWSSensorType){
        if(type == .bufferLimitReached && sensingDataBuffer != nil){
            sendData(forType: stype)
        }
    }
    
    func sendData(forType type: AWSSensorType){
        lastTransmissions[type] = Date()
        let (batchNo, data) = sensingDataBuffer!.prepareDataToSend(forType: type)
        let message = SensingDataMessage(withSensingData: data, ofType: type)
        CommunicationManager.instance.send(message: message)
    }

}





