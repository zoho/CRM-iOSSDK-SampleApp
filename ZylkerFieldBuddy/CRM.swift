//
//  Data.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 01/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import Foundation
import MapKit

class CRM {
    
    
    static private var model = Model()
    
    
    static var pendingJobData = [Job]()
    
    
    // pendingJobData records are moved here as they are completed
    static var completedJobData = [Job]()
    
    
    static var contacts = [Contact]()
    
    
    static var jobcards = [Jobcard]()
    
    
    // prevents Login Page Popup
    static var didShowLoginPage = false
    
    
    static var currentUserCoords = CLLocationCoordinate2D()
    
    // used by JobCardCC
    static var currentJobIndex = Int()
    
    
    // required by more than one VC -> Shifted here
    static func getJobTimeLabel(date:Date)->String{
        
        let calender = Calendar.current
        
        var flag:time
        
        let components = calender.dateComponents([.hour,.minute,.second], from: date)
        
        let tempHour = components.hour!
        
        var hour = Int()
        
        if tempHour > 12 {
            
            hour = tempHour - 12
            flag = time.PM
            
            
        }
        else if tempHour == 12 {
            
           hour = tempHour
            flag = time.AM
            
        }
        
        else{
            
            hour = tempHour
            flag = time.AM
            
        }
        
        let tempMinute = components.minute!
        var minute = String()
        
        
        if tempMinute == 0 {minute = String(tempMinute) + "0"}
        else {minute = String(tempMinute) }
        
        return "\(hour):\(minute) \(flag.rawValue)" // 11:30 A.M
        
        
        
    } // getJobTimeLabel
    
    
    enum time:String{
        
        case AM = "AM"
        case PM = "PM"
        
    }
    
    
    static func getImagePath() -> URL?
    {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        guard let imagePath = documentDirectory?.appendingPathComponent("image.jpeg")
            else
        {
            print("Image Path Fetch Failed !")
            return nil
        }
        
        return imagePath
    }
    
    
    enum menuViews:String {
        
        case pendingJobs = "Pending Jobs"
        case completedJobs = "Completed Jobs"
        case contacts = "Contacts"
        case jobCards = "jobCards"
        case mapsView = "Maps"
        case special // used to load initial API data
        
    }
    
    // used for fetching relevant data by TableView
    static var currentView = menuViews.mapsView // default value
    
 
}

// attachmentData = try? jobCards[i].downloadAttachment(attachmentId: attachmentID).getFileData()

