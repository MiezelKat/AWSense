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
    
    
    // MARK: - methods
    
    func initialise(withSession session: SensingSession){
        sensingDataBuffer = SensingDataBuffer(withSession: session)
        sensingDataBuffer?.subscribe(handler: self)
    }
    
    func manage(sensingData data : AWSSensorData, forType type: AWSSensorType){
        sensingDataBuffer!.append(sensingData: data, forType: type)
    }
    
    func sessionStopped(){
        if(sensingDataBuffer != nil){
            for s in sensingSession!.sensorConfig.enabledSensors{
                sendDataFile(forType: s)
            }
        }
    }
    
    // MARK: - SensingBufferEventHandler

    func handle(withType type: SensingBufferEventType, forSensor stype: AWSSensorType){
        if(type == .bufferLimitReached && sensingDataBuffer != nil){
            sendDataFile(forType: stype)
        }
    }
    
    func sendDataFile(forType type: AWSSensorType){
        sensingDataBuffer!.sendFile(forType: type)
    }

}





