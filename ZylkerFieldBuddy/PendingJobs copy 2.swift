//
//  TableViewController.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 12/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import UIKit

class PendingJobs:UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageTitle: UILabel!
    
  
    
    var currentView:CRM.menuViews?
    
    //
    var tableCellTitle = [String]()
    
    var tableCellSubtitle = [String]()
    
    var selectedIndex = Int()
    

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        currentView = CRM.currentView
        setDataForCurrentView()
        
    }
    
    
    override var prefersStatusBarHidden: Bool{
        
        return true
    }
    
    
    func setDataForCurrentView()
    {
        
        
        if currentView == CRM.menuViews.contacts {
            
            self.title = CRM.menuViews.contacts.rawValue
            
            CRM.jobData.map({ (job) -> () in
                
                tableCellTitle.append(job.customerName)
            })
            
            
        }
            
        else if currentView == CRM.menuViews.jobCards {
            
            self.title = CRM.menuViews.jobCards.rawValue
            
            CRM.jobData.map({ (job) -> () in
                
                tableCellTitle.append(job.jobName)
                
                let jobTime = CRM.getJobTimeLabel(date: job.jobTime)
                
                tableCellSubtitle.append(jobTime)
            })
            
            
        }
        
        else if currentView == CRM.menuViews.completedJobs {
            
            self.title = CRM.menuViews.completedJobs.rawValue
            
            CRM.completedJobData.map({ (job) -> () in
                
                tableCellTitle.append(job.customerName)
            })
            
            
        }
        
        
    } // func ends
    

} // class


extension TableViewController :UITableViewDataSource,UITableViewDelegate
{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return tableCellTitle.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
       
        cell.Title.text = tableCellTitle[indexPath.row]
        cell.subTitle.text = tableCellSubtitle[indexPath.row]
      
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
  
        selectedIndex = indexPath.row
        CRM.currentJobIndex = selectedIndex
        performSegue(withIdentifier: "pendingJobs->jobCards", sender: self)
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is JobCard {
        
        let jobCard = segue.destination as! JobCard
        
        jobCard.indexToFetchData = selectedIndex
            
        }
        
    }
    
   
}
