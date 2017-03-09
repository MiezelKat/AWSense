//
//  RemoteSensingDataBuffer.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 06/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared


internal class RemoteSensingFileHandler{
    
        // MARK: - singleton
    
        static let instance : RemoteSensingFileHandler = RemoteSensingFileHandler()
    
        // MARK: - properties
    
        var sensingSession : RemoteSensingSession?
    
        func initialise(withSession session: RemoteSensingSession){
            sensingSession = session
        }

    internal func handleFileReceived(url: URL, forType type: AWSSensorType) -> URL?{
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths.first!
        let dataPath = documentsDirectory.appending("/\(sensingSession!.id)")
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        let name = sensingSession!.name != nil ? sensingSession!.name! : "export"
        let path = dataPath.appending("/\(name)_\(type.short).csv")
        
        let fileManager = FileManager.default
        
        // Copy 'hello.swift' to 'subfolder/hello.swift'
        let localURL = URL(fileURLWithPath: path)
        do {
            try fileManager.copyItem(at: url, to: localURL)
            return localURL
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        return nil
    }
    
}


//internal class RemoteSensingDataBuffer {
//
//    // MARK: - singleton
//    
//    static let instance : RemoteSensingDataBuffer = RemoteSensingDataBuffer()
//    
//    // MARK: - properties
//    
//    var sensingSession : RemoteSensingSession?
//    
//    var sensingBuffers : [AWSSensorType : [AWSSensorData]]
//
//    
//    // MARK: - init
//    
//    private init(){
//        sensingBuffers = [AWSSensorType : [AWSSensorData]]()
//        for s : AWSSensorType in AWSSensorType.supportedSensors{
//            sensingBuffers[s] = [AWSSensorData]()
//        }
//    }
//
//    
//    // MARK: - methods
//    
//    func initialise(withSession session: RemoteSensingSession){
//        sensingSession = session
//        clearAllBuffers()
//    }
//    
//    func append(sensingData data: [AWSSensorData], forType type: AWSSensorType){
//        sensingBuffers[type]!.append(contentsOf: data)
//    }
//    
//    func serialiseAll(){
//        
//        let userDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        let rootDirectory = userDirectory.appending("/\(sensingSession!.id)")
//        
//        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        let documentsDirectory = paths.first!
//        let dataPath = documentsDirectory.appending("/\(sensingSession!.id)")
//        
//        do {
//            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)                
//                //.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: false, attributes: nil)
//        } catch let error as NSError {
//            print(error.localizedDescription);
//        }
//        
//        for s in sensingSession!.sensorConfig.enabledSensors {
//            let name = sensingSession!.name != nil ? sensingSession!.name! : "export"
//            let path = rootDirectory.appending("/\(name)_\(s.short).csv")
//            print(path)
//            
//            var writeString : String = s.csvHeader
//            let data = sensingBuffers[s]!
//            
//            for d in data {
//                writeString.append(d.csvString)
//            }
//            
//            do{
//                try writeString.write(toFile: path, atomically: true, encoding: .utf8)
//            }catch let error as Error{
//                print("did not write file for type \(s.short)")
//                print(error.localizedDescription)
//            }
//        }
//        
//        clearAllBuffers()
//    }
//    
//    private func clearAllBuffers(){
//        // reset the buffer
//        for s : AWSSensorType in AWSSensorType.supportedSensors{
//            sensingBuffers[s]!.removeAll()
//        }
//    }
//}
