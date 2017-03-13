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
    
    func serialiseAndSend(forType type: AWSSensorType, batchNo: Int) {

        var writeString : String = type.csvHeader
        // copy of the buffer
        let data = self.sensingBuffers[type]!
        
        // do it asyncronously
        writeQueue.async{
            
            let rootDirectory = NSTemporaryDirectory().appending("/\(self.sensingSession.id)")
            
            do {
                try FileManager.default.createDirectory(atPath: rootDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
            
            let name = "export"
            
            let path = rootDirectory.appending("/\(name)_\(batchNo)_\(type.short).csv")
            print(path)
            
            
            for d in data {
                if(d != nil){
                    writeString.append(d.csvString)
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
