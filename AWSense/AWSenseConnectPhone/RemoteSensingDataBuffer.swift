//
//  RemoteSensingDataBuffer.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 06/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation


internal class RemoteSensingDataBuffer {

    // MARK: - singleton
    
    static let instance : RemoteSensingDataBuffer = RemoteSensingDataBuffer()
    
    // MARK: - buffer size limits
    
    let bufferLimit = 1024// * 10
    
    // MARK: - properties
    
    var sensingSession : RemoteSensingSession?
    
    var sensingBuffers : [AWSSensorType : [AWSSensorData]]
    var sensingBufferBatchNo : [AWSSensorType : Int]
    
    // MARK: - init
    
    private init(){
        sensingBuffers = [AWSSensorType : [AWSSensorData]]()
        sensingBufferBatchNo = [AWSSensorType: Int]()
        for s : AWSSensorType in AWSSensorType.supportedSensors{
            sensingBuffers[s] = [AWSSensorData]()
            sensingBufferBatchNo[s] = 1
        }
    }

    
    // MARK: - methods
    
    func initialise(withSession session: RemoteSensingSession){
        sensingSession = session
        clearAllBuffers()
    }
    
    func append(sensingData data: [AWSSensorData], forType type: AWSSensorType){
        sensingBuffers[type]!.append(contentsOf: data)
        
        if(sensingBuffers[type]!.count > bufferLimit){
            serialise(forType: type)
        }
    }
    
    func serialise(forType type: AWSSensorType){
        let batchNo = sensingBufferBatchNo[type]!
        
        let dirToWrite : String = sensingSession!.dirToWrite == nil ? sensingSession!.id : sensingSession!.dirToWrite!.appending("/aw")
    
        let userDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let rootDirectory = userDirectory.appending("/\(dirToWrite)")
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths.first!
        let dataPath = documentsDirectory.appending("/\(dirToWrite)")
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)
            //.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        let name = sensingSession!.name != nil ? sensingSession!.name! : "export"
        //let path = rootDirectory.appending("/\(name)_\(batchNo)_\(type.short).csv")
        
        let path = rootDirectory.appending("/a\(type.short.localizedUppercase)_\(batchNo).csv")
        
        print(path)
        
        var writeString : String = type.csvHeader
        let data = sensingBuffers[type]!
        
        for d in data {
            writeString.append(d.csvString)
        }
        
        do{
            try writeString.write(toFile: path, atomically: true, encoding: .utf8)
        }catch let error as Error{
            print("did not write file for type \(type.short)")
            print(error.localizedDescription)
        }

        clearBuffer(forType: type)
        
        sensingBufferBatchNo[type]! = batchNo + 1
    }
    
    func serialiseAll(){

        for s in sensingSession!.sensorConfig.enabledSensors {
            serialise(forType: s)
        }
    }
    
    private func clearAllBuffers(){
        // reset the buffer
        for s : AWSSensorType in AWSSensorType.supportedSensors{
            clearBuffer(forType: s)
        }
    }
    
    private func clearBuffer(forType type: AWSSensorType){
        sensingBuffers[type]!.removeAll()
    }
}
