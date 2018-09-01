//
//  JobEntryCC.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 08/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import Foundation
import ZCRMiOS

class JobEntryCC {
    
  
    private var record:ZCRMRecord?
    weak var view = JobEntryVC()
   
   
    
    public func uploadRecord(_ pendingJobData:String ,didUploadRecord: (Bool)->() )
    {
        
        let jobDoneTime = Date().iso8601
        let jobID = Int64(CRM.pendingJobData[CRM.currentJobIndex].jobId)
     
   
  
        record = ZCRMRecord( moduleAPIName :"Surveys" )

        record?.setValue( forField : "Visit_Time", value : jobDoneTime )
        record?.setValue( forField : "Name", value : pendingJobData )
        record?.setValue( forField : "Appointment", value : jobID )

        
        
        // creates and gets the newly created record ID
        guard let recordID = getRecordID() else
            
        {
        
            print("no record id")
            didUploadRecord(false) // failure Case!
            return
            
        }

        let filePathString =  CRM.getImagePath()?.path

        do
        {

            // uploads attachment using created Record ID
            
            let response:APIResponse = try ZCRMRecord(moduleAPIName:"Surveys", recordId: recordID).uploadAttachment(filePath: filePathString!)
            
            
            if response.getStatus() == "success"
            {
                guard updateRecordStatus(For: jobID!) != nil else {
                   
                    didUploadRecord(false)
                    return
                    
                }
                didUploadRecord(true)
                
            }
            
            else
            {
                print("Upload Attachment Response : Failed !")
                didUploadRecord(false)
                
            }
            

        }

        catch
        {

            print("Upload Attachment Call Failed !")
            didUploadRecord(false)

        }
        
        
    }
    
    

    
    private func getRecordID() -> Int64?
    {
        do
        {
            let response : APIResponse = (try record?.create())!
            if response.getStatus() == "success"
            {
                return record!.getId()
            }
        }
        catch
        {
            print( "Failed to Create Record \(error)" )
        }
        
        return nil
    }
    
    
    
    private func updateRecordStatus(For recordId:Int64)->Bool?
    {
        do
        {
            let record : ZCRMRecord = ZCRMRecord(moduleAPIName: "Appointments", recordId: recordId)
            record.setValue( forField : "Status", value : "Completed" )
            let response : APIResponse = try record.update()
            
            if ( response.getStatus() == "success" )
            {
                return true
            }
            else
            {
              print("Failed to update Record status !")
              return false
            }
            
        }
        catch
        {
            print( "Error occured in updateRecordStatus : \(error)" )
        }
        
        return nil
    }
    
    
  
} // end of class
