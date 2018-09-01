//
//  TableViewController.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 12/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import UIKit

class Contacts:UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        loadContactsData()
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
        refresher.addTarget(self, action: #selector(self.refreshAPIData), for: .valueChanged)
        
        tableView.addSubview(refresher)
    }
    
    
    
    func loadContactsData()
    {
        
        tableCellTitle.removeAll()
        tableCellSubtitle.removeAll()
        
        
        CRM.contacts.map({ (contact) -> () in
            
            tableCellTitle.append(contact.name)
            tableCellSubtitle.append(contact.email)
        })
      
        
        
    } // func ends
    
    
    
    func refreshAPIData()
    {
        
        model.loadAPIdata(For: CRM.menuViews.contacts) {
            
            (didFinishLoadingAPIData) in
            
            if didFinishLoadingAPIData == true {
                
                self.loadContactsData()
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                    
                }
                
            }
            
        }
        
        
    }
    
    
    
} // class


extension Contacts : UITableViewDataSource , UITableViewDelegate
{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return tableCellTitle.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.Title.text = tableCellTitle[indexPath.row]
        
        if ( tableCellSubtitle[indexPath.row] == "absent" )
        {
            cell.subTitle.text = "Email not availabale"
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        selectedIndex = indexPath.row
        CRM.currentJobIndex = selectedIndex
        performSegue(withIdentifier: "contacts->contactDetails", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is ContactDetailsView {
            
            CRM.currentView = CRM.menuViews.contacts
            
            let contactDetailsVC = segue.destination as! ContactDetailsView
            
            contactDetailsVC.indexToFetchData = selectedIndex
            
        }
        
    }
    
    
}
