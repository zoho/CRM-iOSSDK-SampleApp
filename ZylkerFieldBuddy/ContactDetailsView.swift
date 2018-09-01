//
//  ContactDetailsView.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 14/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import UIKit

class ContactDetailsView: UIViewController {

    @IBOutlet weak var contactName: UILabel!
    
    @IBOutlet weak var accountName: UILabel!
    
    @IBOutlet weak var contactEmail: UILabel!
    
    @IBOutlet weak var contactNumber: UILabel!
    
    var indexToFetchData = Int()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        populateContactDetailsCard()
        
    }

    func populateContactDetailsCard() {
        
        let contact = CRM.contacts[indexToFetchData]
        
        contactName.text = contact.name
        accountName.text = checkIfValueExists(value: contact.accountName)
        contactEmail.text = checkIfValueExists(value: contact.email)
        contactNumber.text = checkIfValueExists(value: contact.phone)
      
    }
    
    
    func checkIfValueExists(value:String)->String
    {
        
        if value == "absent" {
            return "not available"
        }
        
        return value
    }


}
