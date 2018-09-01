//
//  CardKeeper.swift
//  Pods-TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 06/03/18.
//

import Foundation

class CardKeeper{
    
    
    internal static var currentCardNumber = Int()
    private var firstCard = true
    private let count:Int = CRM.jobCount() - 1
    
    
    func nextCard()->Job {
        
        
        if count >= ( CardKeeper.currentCardNumber + 1 ) {
            
            CardKeeper.currentCardNumber += 1
            
            return CRM.jobData[CardKeeper.currentCardNumber]
            
        } else {  // swiping last card gives first card
            
           
            CardKeeper.currentCardNumber = 0
            return CRM.jobData[0] // first card
            
            
        }
        
    }
        
    
    
    func previousCard()->Job{
        
        
        if (CardKeeper.currentCardNumber - 1) >= 0{
            
            CardKeeper.currentCardNumber -= 1
            
            return CRM.jobData[CardKeeper.currentCardNumber]
            
        } else { // swiping back from first card gives last card
            
            CardKeeper.currentCardNumber = count
            return CRM.jobData[count] // last card
            
        }
        
        
    }
    
    
    func getFirstCard()->Job?{
        
        if firstCard {
        
        firstCard = false
        CardKeeper.currentCardNumber = 0
        return CRM.jobData[0]
            
        }
        
        return nil
    }

  
} // class ends
