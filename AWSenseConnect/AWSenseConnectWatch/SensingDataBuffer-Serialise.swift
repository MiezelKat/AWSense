//
//  FileHelper.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 09/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared

internal extension SensingDataBuffer{
    

    
    func serialise(forType type: AWSSensorType, batchNo: Int) {

        var writeString : String = type.csvHeader
        let data = self.sensingBuffers[type]!
        
        writeQueue.async{
            
            let rootDirectory = NSTemporaryDirectory().appending("/\(self.sensingSession.id)")
            
            do {
                try FileManager.default.createDirectory(atPath: rootDirectory, withIntermediateDirectories: true, attributes: nil)
                //.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
            
            let name = "export"
            
            let path = rootDirectory.appending("/\(name)_\(batchNo)_\(type.short).csv")
            print(path)
            
            
            
            let count = data.count - 1
            //for d in data {
            for i in 0...count-1{
                if(data[i] != nil){
                    writeString.append(data[i]!.csvString)
                    self.sensingBuffers[type]![i] = nil
                }
            }
            
            do{
                try writeString.write(toFile: path, atomically: true, encoding: .utf8)
                let url = URL(fileURLWithPath: path)
                
                let message = SensingFileMessage(withURL: url, ofType: type, batchNo: batchNo)
                CommunicationManager.instance.send(message: message, userInfo: true)
            }catch let error as Error{
                print("did not write file for type \(type.short)")
                print(error.localizedDescription)
            }

        }
    }
    
}
