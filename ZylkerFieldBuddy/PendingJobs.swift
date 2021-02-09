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
    
    
    var currentView:CRM.menuViews?
    
    var tableCellTitle = [String]()
    
    var tableCellSubtitle = [String]()
    
    var selectedIndex = Int()
    
    var refresher:UIRefreshControl!
    
    private lazy var model = Model()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadPendingJobs()
        clearHighlightedCells()
        
    }
    
    
    override var prefersStatusBarHidden: Bool{
        
        return true
    }
    
    @IBAction func closePendingJobs(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    
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
        refresher.addTarget(self, action: #selector(self.refreshAPIData), for: .valueChanged)
        
        tableView.addSubview(refresher)
    }
    
    
    
    func loadPendingJobs()
    {
        
        tableCellTitle.removeAll()
        tableCellSubtitle.removeAll()
        
        
        CRM.pendingJobData.map({ (job) -> () in
            
            tableCellTitle.append(job.jobName)
            
            let jobTime = CRM.getJobTimeLabel(date: job.jobTime)
            
            tableCellSubtitle.append(jobTime)
        })
        
    } // func ends
    
    
    
    @objc func refreshAPIData()
    {
        
        model.loadAPIdata(For: CRM.menuViews.pendingJobs){
          
            (didFinishLoadingAPIData) in
            
            if didFinishLoadingAPIData == true {
            
                self.loadPendingJobs()
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                    
                }
               
            }
            
        }
      
        
    }
    
    
} // class


extension PendingJobs : UITableViewDataSource , UITableViewDelegate
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
        
        if segue.destination is AppointmentCard {
            
            CRM.currentView = CRM.menuViews.pendingJobs
            
            let jobCard = segue.destination as! AppointmentCard
            
            jobCard.indexToFetchData = selectedIndex
            
        }
        
    }
    
    
}
