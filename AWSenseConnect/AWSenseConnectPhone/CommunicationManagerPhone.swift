//
//  CommunicationManagerPhone.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 02/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSSharedPhone

extension CommunicationManager {
    


    
    // MARK: - methods sending
    
    
    func transmittSensingSample(data : AWSSensorData){
        
        connectivityManager.sendMessage(message: nil)
        
    }
    
    

    
    
    // MARK: - methods handling received
    
    
    
}
