//
//  ViewController.swift
//  TestiOSAPPZohoAuth
//

import UIKit
import ZCRMiOS
import MapKit

class ViewController: UIViewController
    
{
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    private let model = Model()
    
    private var currentCardNumber = Int()
    
    var indexOfMarker = Int() // passed to JobCard VC
    
    var isFirstMapZoom = true
    
    @IBOutlet weak var refreshMapButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    
    override func viewDidLoad()
        
    {
        super.viewDidLoad()
        
        
        if CRM.didShowLoginPage == false
            
        {
            
            ( UIApplication.shared.delegate as! AppDelegate ).loadLoginView
                {
                    
                    ( isSuccessfulLogin ) in
                    
                    if isSuccessfulLogin == true
                    {
                        CRM.didShowLoginPage = true
                        self.loadAPIData()
                        
                    }
                    
                }
            

        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    
    CRM.currentView = CRM.menuViews.mapsView
    loadJobLocations()
    
    }
    
    
    
    func loadAPIData()
    {
        
        
        self.model.loadAPIdata(For: CRM.menuViews.special) {
            
            (didFinishLoadingAPIData) in
            
            guard didFinishLoadingAPIData else {
                print("Failed to fetch Data")
                return
            }
            
            self.startMapOperations()
           
            
        } // end of loadAPIData
    
    }
    
    

    @IBAction func showPendingJobs(_ sender: Any)
    {
        
        let pendingJobsTableView = self.storyboard?.instantiateViewController(withIdentifier: "pendingJobs") as?
            PendingJobs
        
        self.navigationController?.pushViewController(pendingJobsTableView!, animated: true)
        
    }
    
    @IBAction func moveFocusToUserLocation(_ sender: Any)
    {
     
        showUserLocation()
        
    }
    
    @IBAction func refreshAPIData(_ sender: Any)
    {
        
        // disabling until new data has been loaded
        refreshMapButton.isEnabled = false
        
        model.loadAPIdata(For: CRM.menuViews.pendingJobs) {
            
            (didFinishLoadingAPIData) in
            
            if didFinishLoadingAPIData == true
            {
                DispatchQueue.main.async
                {
                    self.refreshMapButton.isEnabled = true
                }
                self.loadJobLocations()
                
            }
            
        } // loadAPIData closure ends //
        
     
    }
    
    @IBAction func logout(_ sender: Any) {
        
        
        let logoutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to continue ?", preferredStyle: .alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (alert) in
            
            ( UIApplication.shared.delegate as! AppDelegate ).logout(completion: { (success) in
                if( success == true )
                {
                     UserDefaults.standard.set(false, forKey: "isUserLoggedIn" )
                    print( "logout successful" )
                }
            })
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
       
        self.present(logoutAlert, animated: true, completion: nil)
    }
    
    
} // class

extension ViewController : MKMapViewDelegate , CLLocationManagerDelegate {
    
    
    
    func startMapOperations()
    {
        loadJobLocations()
        startLocationManager()
    }
    
    
    // clears map and loads markers
    func loadJobLocations()
    {
    
        mapView.removeAnnotations(mapView.annotations)
        
        for job in CRM.pendingJobData
            
        {
            
            let latitude = job.customerLocation.latitude
            let longitude = job.customerLocation.longitude
   
            let jobLocation = MKPointAnnotation()
            
            jobLocation.title = job.jobName
            
            jobLocation.subtitle = CRM.getJobTimeLabel(date: job.jobTime)
            
            jobLocation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            mapView.addAnnotations([jobLocation])
            
        }
        
    }
    
    
    
    func startLocationManager()
    {
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.showsBackgroundLocationIndicator = true
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        CRM.currentUserCoords = locations[0].coordinate
        
        if isFirstMapZoom == true {
            
            // zoomed into user Location Only once
            showUserLocation()
            isFirstMapZoom = false
        }
        
    }
    
    
    
    func showUserLocation()
    {
  
        let currentLocation = CRM.currentUserCoords
        
        let zoom:MKCoordinateSpan = MKCoordinateSpanMake(0.5, 0.5)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(currentLocation, zoom)
        
        mapView.setRegion(region, animated: true)
     
    }
 
   

    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
  
     
        
 
     } // func ends
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
       
        if annotation is MKUserLocation {
            
            return nil
        }
        
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        pin.canShowCallout = true
        
        pin.animatesDrop = false
        
        pin.pinTintColor = UIColor.red
        
        pin.rightCalloutAccessoryView = UIButton( type : .infoDark )
        
        return pin
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
        
    {
        let selectedJobMarker = view.annotation
        
       
        let latitude = selectedJobMarker?.coordinate.latitude
        let longitude = selectedJobMarker?.coordinate.longitude
        
        
        getPendingJobDataIndex(For: latitude!, longitude: longitude!) {
            
            (isIndexGetSuccess:Bool , Retreivedindex:Int) in
            
            if isIndexGetSuccess == true {
                
                indexOfMarker = Retreivedindex
                
                CRM.currentJobIndex = indexOfMarker
                
            }
            
        }
        
   
        
        if control == view.rightCalloutAccessoryView
        {
            performSegue(withIdentifier: "Map->JobCard", sender: self)
        }
        
        
        
    }
    
   
    
    func getPendingJobDataIndex(For latitude:Double,longitude:Double,Done:(Bool,Int)->())
    {
        
        for (index,job) in CRM.pendingJobData.enumerated() {
            
            
            if job.customerLocation.latitude == latitude &&
                job.customerLocation.longitude == longitude{
                
                Done(true,index)
                
            }
            
        }
        
        Done(false,-1)
      
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is AppointmentCard {
            
            
            let jobCardVC = segue.destination as! AppointmentCard
            
            jobCardVC.indexToFetchData = indexOfMarker
            
            
        }
      
    }
    
   
}




