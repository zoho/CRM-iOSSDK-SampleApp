//
//  Entity.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 01/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import Foundation


struct Job {
    
    
    let customerName:String
    let customerAddr:String
    let customerLocation:Coords
    let jobName:String
    let jobId:String
    let jobTime:Date
    
    
    init ( customerName:String , customerAddr:String , customerLocation:Coords , jobName:String , jobTime:Date , jobId:String )
    {
        
        self.customerName = customerName
        self.customerAddr = customerAddr
        self.customerLocation = customerLocation
        self.jobName = jobName
        self.jobId = jobId
        self.jobTime = jobTime
        
    }
    
}

struct Contact {
    
    let name:String
    let accountName:String
    let email:String
    let phone:String
    
    init(name:String,accountName:String,email:String,phone:String) {
        
        self.name = name
        self.accountName = accountName
        self.email = email
        self.phone = phone
     
    }
    
}


struct Jobcard {
    
    
    let jobId:String
    let jobName:String
    let jobDescription:String
    let jobAttachmentID:String?
    let jobCardId:String
    
}



struct Coords {
    
    let latitude:Double
    let longitude:Double
    
    init(latitude:Double,longitude:Double){
        
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
}
