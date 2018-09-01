//
//  Extensions.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 05/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import Foundation
import UIKit
import ZCRMiOS

extension UIImage
{

    static func downloadImage(For attachmentId:Int64,jobCardId:Int64 , didFetchimage:(Bool,UIImage?)->() )
   {
        
    
    do
    {
        let module : ZCRMModule = ZCRMModule(moduleAPIName: "Surveys")
        
        let jobCard : ZCRMRecord?  = try module.getRecord(recordId: jobCardId).getData() as? ZCRMRecord
        
        guard jobCard != nil else { didFetchimage(false,nil);return }
        
        let data = try? jobCard!.downloadAttachment(attachmentId: attachmentId).getFileData()
        
        guard data != nil else {
            didFetchimage(false,nil)
            return
        }
        
        didFetchimage(true,UIImage(data: data!) )
    }
    catch
    {
        print( "Error : \( error )" )
    }
    
    }
    

}


extension Date {
    
    static func ISOStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: date).appending("Z")
    }
    
    static func dateFromISOString(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: string)
    }
}


