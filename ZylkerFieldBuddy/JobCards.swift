//
//  JobCards.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 16/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import UIKit

class JobCards: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
   
    
    var currentView:CRM.menuViews?
    
    var tableCellTitle = [String]()
    
    var selectedIndex = Int()
    
    var refresher:UIRefreshControl!
    
    private lazy var model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadJobCards()
        clearHighlightedCells()
    }
    
    
    override var prefersStatusBarHidden: Bool{
        
        return true
    }
    
    
    func clearHighlightedCells(){
        
        
        guard let highLightedCell = tableView.indexPathForSelectedRow
            else {return}
        
        tableView.deselectRow(at:highLightedCell, animated: true)
        
    }
    
    
    func addRefreshControl()
    {
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(CompletedJobs.refreshAPIData), for: .valueChanged)
        
        tableView.addSubview(refresher)
    }
    
    
    
    func loadJobCards()
    {
        
        tableCellTitle.removeAll()
        
        CRM.jobcards.map({ (job) -> () in
            
            tableCellTitle.append(job.jobName)
            
    
        })
        
        
    } // func ends
    
    
    func refreshAPIData()
    {
        
        model.loadAPIdata(For: CRM.menuViews.jobCards) {
            
            (didFinishLoadingAPIData) in
            
            if didFinishLoadingAPIData == true {
                
                self.loadJobCards()
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                    
                }
                
            }
            
        }
        
        
    }

}



extension JobCards : UITableViewDataSource , UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return tableCellTitle.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.Title.text = tableCellTitle[indexPath.row]
        
        cell.subTitle.text = ""
      
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        selectedIndex = indexPath.row
        CRM.currentJobIndex = selectedIndex
        performSegue(withIdentifier: "jobCards->jobCardsDetail", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is JobEntryVC {
            
            let jobEntryVC = segue.destination as! JobEntryVC
            
            jobEntryVC.job_ImageId = CRM.jobcards[selectedIndex].jobAttachmentID
            jobEntryVC.jobDescription = CRM.jobcards[selectedIndex].jobDescription
            jobEntryVC.jobCardId = CRM.jobcards[selectedIndex].jobCardId
            jobEntryVC.jobId = CRM.jobcards[selectedIndex].jobId
        }
        
    }
    
    
}



