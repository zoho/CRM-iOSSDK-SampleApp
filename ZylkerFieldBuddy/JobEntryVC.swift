//
//  JobEntryVC.swift
//  TestiOSAPPZohoAuth
//
//  Created by Karthik Shiva on 07/03/18.
//  Copyright © 2018 TestiOSAPPZohoAuthOrg. All rights reserved.
//

import UIKit

class JobEntryVC: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    
    @IBOutlet weak var pendingJobData: UITextView!
    @IBOutlet weak var job_Image: UIImageView!
    @IBOutlet weak var addData: UIButton!
    @IBOutlet weak var imagePlaceHolderBtn: UIButton!
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var FinishButton: UIButton!
    
    let imageLibrary = UIImagePickerController()
    let cameraImage = UIImagePickerController()
    
    lazy var controller = JobEntryCC()
    
    var imagePath:URL?
    
    var selectedImage:UIImage?
    
    var activityIndicator:UIActivityIndicatorView?
    
    var isCameraAvailable = true
    
    var pageUsedFor:pageMode!

    // used for displaying mode
    var jobDescription:String?
    var job_ImageId:String?
    var jobCardId:String?
    var jobId:String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        checkJobEntryOrDisplay()
        
       
    }
    
    func checkJobEntryOrDisplay()
    {
        guard pendingJobData != nil , job_ImageId != nil else {
            setUpViewForJobEntry()
            return
        }
        
        setUpViewForJobDisplay()
    }
    
    
    func setUpViewForJobEntry(){
        
        pageUsedFor = pageMode.entry
        pageTitle?.text = "JOB ENTRY"
        FinishButton.setTitle("DONE", for: .normal)
        
        // default file-save location
        imagePath = CRM.getImagePath()
        configureImageAccess()
        
        
    }
    
    func setUpViewForJobDisplay() {
        
        pageUsedFor = pageMode.display
        imagePlaceHolderBtn.isHidden = true
        pageTitle?.text = "JOB CARD"
        FinishButton.setTitle("VIEW APPOINTMENT", for: .normal)
        
        let imageId = Int64(job_ImageId!)
        let jobCardID = Int64(jobCardId!)
        self.activityIndicator = UIActivityIndicatorView()
        
        DispatchQueue.global(qos: .userInteractive).async
        {
            
            self.startActivityIndicator(position: indicatorPosition.middleOfImageView)
            
            
                UIImage.downloadImage(For: imageId!, jobCardId: jobCardID!)
                {
                    (didFetchImage,image) in
                    
                    if didFetchImage == true
                    {
                    
                    DispatchQueue.main.async
                        {
                          
                          self.job_Image.image = image
                          self.stopActivityIndicator()
                        }
                    
                     } //if ends
                    
                    else
                    {
                        self.notifyUser(title: "Image Fetch Error", message: "Try again later !")
                        self.stopActivityIndicator()
                        
                    }
                    
                    
                } // end of trailing closure
            
            
            
        }
 
        pendingJobData.text = jobDescription
        pendingJobData.isEditable = false
    
    }
    
  
    
    @IBAction func addData(_ sender: Any)
    {

        if pageUsedFor == pageMode.entry{
            
            uploadData()
            
        } else {
            
            goToAppointmentCard()
        }
  
        
    }
    
    
    
    func uploadData(){
        
        
        
        guard !checkEmptyFields() else {return}
        let jobInfo = pendingJobData.text!
        
        activityIndicator = UIActivityIndicatorView()
        startActivityIndicator(position: indicatorPosition.middleOfView)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.controller.uploadRecord(jobInfo){
                
                if $0
                {
                    self.stopActivityIndicator()
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "Jobentry->MapView", sender: self)
                    }
                    
                    self.markJobAsCompleted()
                    
                } else {
                    
                    self.stopActivityIndicator()
                    self.notifyUser(title: "Oops..", message: "There was some problem with saving your JobCard \n Try Again Later !")
                    
                }
                
            }
            
        }
        
        
        
        
    }
    
    
    func goToAppointmentCard(){
        
        
        fetchAppointmentIndex(For: jobId!) {
            (done,index) in
            
            if done == true {
            CRM.currentJobIndex = index
            CRM.currentView = CRM.menuViews.completedJobs
            performSegue(withIdentifier: "showAppointment", sender: self)
                
            }
            
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is AppointmentCard{
            
            let appointmentCard = segue.destination as! AppointmentCard
            
            appointmentCard.indexToFetchData = CRM.currentJobIndex
            
            
        }
        
    }
    
    
    
    func fetchAppointmentIndex(For jobId:String ,Done:(Bool,Int)->() ){
        
        for (index,finishedJob) in CRM.completedJobData.enumerated() {
        
            if jobId == finishedJob.jobId {
                
                Done(true,index)
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    @IBAction func chooseImage(_ sender: Any)
    {
        showImageOptions()
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    // Cancel typing on touching outside the Text Box
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        pendingJobData.resignFirstResponder()
    }
    

}// class ends


extension JobEntryVC {  // Image Functions
    
    
    func configureImageAccess()
    {
        checkCameraAvailability()
        
        imageLibrary.delegate = self
        imageLibrary.sourceType = .photoLibrary
        imageLibrary.allowsEditing = false
        
        if isCameraAvailable == true
        {
        
        cameraImage.delegate = self
        cameraImage.sourceType = .camera
        cameraImage.allowsEditing = false
            
        }
        
    }
    
    
    func checkCameraAvailability()
    {
        
    if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            
            isCameraAvailable = false
            notifyUser(title: "Camera Unavailable !", message: "It seems like you are running on a simulator.Please switch to a real-device to use the camera .")
       
        }
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) 
    {
        
         selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if selectedImage != nil{
            
            // hide " Tap to add Image "
            
            imagePlaceHolderBtn.isHidden = true
            
          
            job_Image?.image = selectedImage
            
            writeImageToFile()
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func showImageOptions()
    {
        
    
        let imageOptions = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)
        
        imageOptions.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (alertx) in
            
            self.present(self.imageLibrary, animated: true, completion: nil)
            
        }))
        
        
        if isCameraAvailable == true {
        
        imageOptions.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (alert) in
            
            self.present(self.cameraImage, animated: true, completion: nil)
        }))
            
        }
        
        imageOptions.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(imageOptions, animated: true, completion: nil)
     
    }
    
    
    
    func writeImageToFile()
    {
  
        do
        {
        
        try UIImageJPEGRepresentation(selectedImage!, 0.5)?.write(to: imagePath!)
        }
        
        catch
        {
            notifyUser(title: "Error", message: "Image Write Failed!")
            print("ERROR \n Image Path Might be NIL !")
            print(error)
            
        }
        
    }
    
    

} // extension



extension JobEntryVC
{
    
    
    func notifyUser(title:String,message:String)
    {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (alert) in
            
//            self.performSegue(withIdentifier: "showMapsView", sender: self)
            
        }))
 
        self.present(alert, animated: true, completion: nil)
        
       
    } // notifyUser
    
    
    
    func checkEmptyFields()->Bool
    {
        
        guard job_Image.image != nil else {
            
            notifyUser(title: "Image Missing !", message: "Please Consider attaching an Image !")
            return true
        }
        
        guard pendingJobData.text.count > 1 else {
            
             notifyUser(title: "Job Description Missing !", message: "Please provide the details of the job !")
            return true
        }
        
        return false
        
    }
    
    
    
    // OnSuccess : removes the job from Scheduled jobs and pushes into completed jobs
    
    func markJobAsCompleted()
    {
        
    let completedJob = CRM.pendingJobData[CRM.currentJobIndex]
    CRM.pendingJobData.remove(at: CRM.currentJobIndex)
    CRM.completedJobData.append(completedJob)
        
    }
    

    
    
} // extension ends


// Activity Indicator
extension JobEntryVC {
    
    
    func startActivityIndicator(position:indicatorPosition)
    {
        
        DispatchQueue.main.async {
           
            self.activityIndicator?.hidesWhenStopped = true
            self.activityIndicator?.activityIndicatorViewStyle = .whiteLarge
            self.view.addSubview( self.activityIndicator!)
            self.activityIndicator?.startAnimating()
            
            
            
            if position == indicatorPosition.middleOfView {
                
                self.activityIndicator?.center = self.view.center
                UIApplication.shared.beginIgnoringInteractionEvents()
                
            } else {
                
                self.activityIndicator?.center = self.job_Image.center
                
            }
            
            
            
        }
        

    }
    
 
    func stopActivityIndicator()
    {
       
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            
            if self.pageUsedFor == pageMode.entry{
            UIApplication.shared.endIgnoringInteractionEvents()
            }
            
        }
 
    }
    
   
} // extension end //

enum indicatorPosition {
    
    
    case middleOfView
    case middleOfImageView
    
}

enum pageMode {
    
    case entry
    case display
    
}

