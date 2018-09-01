//
//  TableViewController.swift
//  TestiOSAPPZohoAuth
//

import Foundation
import UIKit

class ContactsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var nameList : [ String ] = [ String ]()
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return( nameList.count )
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = nameList[indexPath.row]
        return cell
    }
}
