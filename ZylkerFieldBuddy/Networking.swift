//
//  MainMenuVC.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 01/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import UIKit
import ZCRMiOS

class Model

{
    
typealias views = CRM.menuViews
    
    public func loadAPIdata(For module:views ,finishedLoadingAPIData:@escaping (Bool)->() )
    {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            switch module {
                
            // used to load initial app data
            case views.special:
                self.getAppointments()
                self.sortAppointments()
                self.getContacts()
                self.getJobCards()
                finishedLoadingAPIData(true)
                
            case views.contacts :
                self.getContacts()
                finishedLoadingAPIData(true)
                
            case views.jobCards:
                self.getJobCards()
                finishedLoadingAPIData(true)
                
            case views.completedJobs:
                self.getAppointments()
                self.sortAppointments()
                finishedLoadingAPIData(true)
                
            case views.pendingJobs:
                self.getAppointments()
                self.sortAppointments()
                finishedLoadingAPIData(true)
                
            default :
                finishedLoadingAPIData(true)
                
            }
       
        }
    
    }
    
    
    
   private func getAppointments()
    {
        
        do
        {
            CRM.pendingJobData.removeAll()
            CRM.completedJobData.removeAll()
            
            let module : ZCRMModule = ZCRMModule(moduleAPIName: "Appointments")
            

//             let jobRecords : [ ZCRMRecord ] = try module.getRecords().getData()  as! [ZCRMRecord]
            
            let jobRecords : [ ZCRMRecord ] = try module.getRecords( cvId : 880428000003643075 ).getData() as! [ZCRMRecord]
            
            if( jobRecords.isEmpty == false )
            {
                
                for i in 0...jobRecords.count - 1
                {
                    
                    
                    let jobStatus = try? jobRecords[i].getValue(ofField: "Status") as! String
                 
                    let time = try? jobRecords[i].getValue(ofField: "Appointment_Time") as! String
                   
                    let jobTime = time?.dateFromISO8601
                    
                    let jobAddr = try? jobRecords[i].getValue(ofField: "Address") as! String
                    
                    let jobName = try? jobRecords[i].getValue(ofField: "Name") as! String
                    
                    let coords = try? jobRecords[i].getValue(ofField: "Lat_Long") as! String
                    
                    let coordsArray = getCoordinates(coords!)
                    
                    let jobCoords:Coords = Coords(latitude: coordsArray[0], longitude: coordsArray[1])
                    
                    
                    let jobID =  String ( jobRecords[i].getId() )
                    
                    
                    let jobCustomerRecord = try? jobRecords[i].getValue(ofField: "Contact") as!
                    ZCRMRecord
                    
                    // gets name of customer
                    let jobCustomerName = (jobCustomerRecord?.getLookupLabel())!
                    
                    guard (jobTime != nil) , (jobAddr != nil),
                          (jobName != nil), ( coords != nil )
                        
                        else {print("Appointments Parsing returned NIL !");continue }
                    
                    
                    if jobStatus != "Completed"
                    {
                
                    CRM.pendingJobData.append(Job(customerName: jobCustomerName, customerAddr: jobAddr!, customerLocation: jobCoords, jobName: jobName!, jobTime: jobTime! , jobId: jobID) )
                        
                    } else {
                        
                        CRM.completedJobData.append(Job(customerName: jobCustomerName, customerAddr: jobAddr!, customerLocation: jobCoords, jobName: jobName!, jobTime: jobTime! , jobId: jobID) )
                    }
                    
                    
                    
                } // for
                
               
                
            }
            
            
        }
            
        catch
        {
            print( "Failed to Fetch Data , Error : \( error )" )
        }
        
    }
    
    
    private func getContacts()
    {
        DispatchQueue.global(qos: .background).async
            {
                CRM.contacts.removeAll()
                let module : ZCRMModule = ZCRMModule(moduleAPIName: "Contacts")
                do
                {
                    let contactDetails : [ ZCRMRecord ] = try module.getRecords().getData()  as! [ZCRMRecord]
                    for i in 0 ..< contactDetails.count
                    {
                        let name = try? contactDetails[i].getValue(ofField: "Full_Name") as! String
                        let accountName = try? contactDetails[i].getValue(ofField: "Account_Name") as? String ?? "absent"
                        let email = try? contactDetails[i].getValue(ofField: "Email") as? String ?? "absent"
                        let phone = try? contactDetails[i].getValue(ofField: "Phone") as? String ?? "absent"
                        CRM.contacts.append(Contact(name: name!, accountName: accountName!, email: email!, phone: phone!) )
                    }
                }
                catch
                {
                    print( "TOO MANY API REQUESTS" )
                }
        }
   }
    
    
    private func getJobCards()
    {
        DispatchQueue.global(qos: .background).async
        {
            let module : ZCRMModule = ZCRMModule(moduleAPIName: "Surveys")
            
            do
            {
                
                let jobCards : [ ZCRMRecord ] = try module.getRecords().getData()  as! [ZCRMRecord]
                
                
                var attachmentID:String?
                
                
                for i in 0 ..< jobCards.count
                {
                    
                    
                    let jobCardId = String(jobCards[i].getId())
                    
                    let subject = try? jobCards[i].getValue(ofField: "Name") as! String
                    
                    guard let appointmentRecord = try! jobCards[i].getValue(ofField: "Appointment") as? ZCRMRecord else {continue}
                    
                    
                    let appoinmentId = String(describing: appointmentRecord.getId())
                    
                    
                    let appointmentName = appointmentRecord.getLookupLabel()
                    
                    do
                    {
                        
                        let attachments:[ZCRMAttachment]? = try jobCards[i].getAttachments().getData() as? [ZCRMAttachment]
                        
                        if attachments?.first?.getId() != nil
                        {
                            
                            attachmentID =   String( (attachments?.first?.getId())! )
                            
                        }
                        
                    }
                    catch
                    {
                        print("TOO MANY API ")
                        return
                    }
                    CRM.jobcards.append(Jobcard(jobId: appoinmentId, jobName: appointmentName!, jobDescription: subject!, jobAttachmentID: attachmentID, jobCardId: jobCardId))
                } // for loop ends
            } catch {
                print("TOO MANY API REQUESTS")
                return
            }
            
        }
    }
        
        
        private func sortAppointments()
        {
            
            CRM.pendingJobData =  CRM.pendingJobData.sorted { one,two in
                
                
                one.jobTime.millisecondsSince1970 < two.jobTime.millisecondsSince1970
                
            }
        }
    }
    
    
    
private func getCoordinates(_ coords:String) ->[Double]
    
{
    print("Received coords \(coords)")
    
    let Lat_Long = coords
    
    var validVal = String()
    var coords = [Double]()
    let dataSize = Lat_Long.count - 1
    
    
    for (c,i) in Lat_Long.enumerated()
        
    {
        
        let validDigit = Int(String(i))
        
        if validDigit != nil{
            
            validVal += String(i)
        }
            
        else if  i == "." || i == "-" {
            
            validVal += String(i)
            
        }
        
        
        
        if i == ":" || c == dataSize {
            
            if validVal != ""{
                
                
                
                coords.append(Double(validVal)!)
                
            }
            
            validVal = ""
            
        }
        
        
    }
    
    return coords
    
} // end of func
    
    
   


