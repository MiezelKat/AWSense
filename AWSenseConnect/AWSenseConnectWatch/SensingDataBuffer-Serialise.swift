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
    

    func serialise(forType type: AWSSensorType) -> URL?{
        
        let rootDirectory = NSTemporaryDirectory().appending("/\(self.sensingSession.id)")
        
        do {
            try FileManager.default.createDirectory(atPath: rootDirectory, withIntermediateDirectories: true, attributes: nil)
            //.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        let name = "export"
        let path = rootDirectory.appending("/\(name)_\(type.short).csv")
        print(path)
        
        var writeString : String = type.csvHeader
        let data = self.sensingBuffers[type]!
        
        for d in data {
            writeString.append(d.csvString)
        }
        
        do{
            try writeString.write(toFile: path, atomically: true, encoding: .utf8)
            return URL(fileURLWithPath: path)
        }catch let error as Error{
            print("did not write file for type \(type.short)")
            print(error.localizedDescription)
        }
        return nil
    }
    
}
