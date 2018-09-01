//
//  JobCardVC.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 07/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import Foundation
import UIKit


class AppointmentCard : UIViewController
{
    
    var indexToFetchData = Int()
    typealias view = CRM.menuViews
    
    @IBOutlet weak var jobName: UILabel!
    @IBOutlet weak var jobCustomer: UILabel!
    @IBOutlet weak var jobAddress: UILabel!
    @IBOutlet weak var jobTime: UILabel!
    @IBOutlet weak var completeJobBtn: UIButton!
    

    @IBAction func completeJob(_ sender: Any)
    {
        // no code required , hooked up in SB

    }
    
    

    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        populateJobCard()
        
        if CRM.currentView == CRM.menuViews.completedJobs{
            
            hideCompleteJobButton()
            
        }
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        indexToFetchData = CRM.currentJobIndex
        print("CURRENT AFTER ",indexToFetchData)
    }
    
    
    func populateJobCard()
    {
        
        // Maps , contacts , JobCards use this
        var Data:Job!
        
        if CRM.currentView == CRM.menuViews.completedJobs {
        
         Data = CRM.completedJobData[indexToFetchData]
            
        } else {
            
        Data = CRM.pendingJobData[indexToFetchData]
            
        }
        
        
        jobName?.text = Data.jobName
        jobTime?.text = CRM.getJobTimeLabel(date:Data.jobTime)
        jobAddress?.text = Data.customerAddr
        jobCustomer?.text = Data.customerName
        
    
    }

    func hideCompleteJobButton(){ // if current job is already completed
        
        completeJobBtn.isHidden = true
        
    }
 
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}

