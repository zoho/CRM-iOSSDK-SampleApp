//
//  ActivityIndicatorUtils.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 09/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorUtils
{
    public func startLoading( activityIndicator : UIActivityIndicatorView, parentView : UIView )
    {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = parentView.center
        activityIndicator.activityIndicatorViewStyle = .gray
        parentView.addSubview( activityIndicator )
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    public func stopLoading( activityIndicator : UIActivityIndicatorView )
    {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
