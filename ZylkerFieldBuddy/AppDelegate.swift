import UIKit

import CoreData

import ZCRMiOS



@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    var window: UIWindow?
    
    var loginHandler : ZCRMLoginHandler?
    
    private var appConfigurationDict : Dictionary< String, Any > = Dictionary< String, Any >()
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        self.initZCRMSDK()
        if let bundleID = Bundle.main.bundleIdentifier
        {
            print( ">>>>>>>>>>>>>>>> bundle ID : \(bundleID)" )
        }
        return true
    }
    

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        loginHandler?.iamLoginHandleURL(url: url, sourceApplication: sourceApplication, annotation: annotation)
        return true
        
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceapp = options[ UIApplicationOpenURLOptionsKey.sourceApplication ]
        loginHandler?.iamLoginHandleURL( url : url, sourceApplication : sourceapp as? String, annotation: "" )
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }
    
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
    
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }
    
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.logout { (success) in
            if( success == true )
            {
                print( "Logout successful - App termination" )
            }
        }
        self.saveContext()
    }
    
    
    
    // MARK: - Core Data stack
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        /*
         
         The persistent container for the application. This implementation
         
         creates and returns a container, having loaded the store for the
         
         application to it. This property is optional since there are legitimate
         
         error conditions that could cause the creation of the store to fail.
         
         */
        
        let container = NSPersistentContainer(name: "TestingWithPod")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                
                // Replace this implementation with code to handle the error appropriately.
                
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                
                
                /*
                 
                 Typical reasons for an error here include:
                 
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 
                 * The device is out of space.
                 
                 * The store could not be migrated to the current model version.
                 
                 Check the error message to determine what the actual problem was.
                 
                 */
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
                
            }
            
        })
        
        return container
        
    }()
    
    
    
    // MARK: - Core Data Saving support
    
    
    
    func saveContext () {
        
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            
            do {
                
                try context.save()
                
            } catch {
                
                // Replace this implementation with code to handle the error appropriately.
                
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func initZCRMSDK()
        
    {
        do
        {
            loginHandler = ZCRMLoginHandler.init()
            self.readConfiguration()
            let appConfig = CRMAppConfigUtil(appConfigDict: appConfigurationDict )
            appConfig.setAppType( type : "ZCRM" )
            loginHandler = try ZCRMLoginHandler(appConfigUtil: appConfig )
            let alreadyLaunched = UserDefaults.standard.bool(forKey:"first")
            if !alreadyLaunched {
                loginHandler!.clearIAMLoginFirstLaunch()
                UserDefaults.standard.set(true, forKey: "first")
            }
            loginHandler!.initIAMLogin( window : self.window )
        }
        catch
        {
            print( "Error occured in AppDelegate.initZCRMSDK(). Details : \( error )" )
        }
    }
    
    private func readConfiguration()
    {
        if let path = Bundle.main.path(forResource : "AppConfiguration", ofType: "plist" )
        {
            self.appConfigurationDict = NSDictionary( contentsOfFile : path ) as! Dictionary< String, Any >
        }
        else
        {
            print("####### appConfigurationDict is empty ######" )
        }
    }
    
    func loadLoginView( completion : @escaping ( Bool ) -> () )
    {
        
        if !UserDefaults.standard.bool(forKey: IsUserLoggedIn) {
            print(UserDefaults.standard.bool(forKey: IsUserLoggedIn))
            
            loginHandler!.handleLogin(completion: { ( success ) in
                UserDefaults.standard.set(true, forKey: self.IsUserLoggedIn)
                completion( success )
            })
        }
        
    }
    
    func logout( completion : @escaping ( Bool ) -> () )
    {
        loginHandler!.logout( completion: { ( success ) in
            UserDefaults.standard.set(false, forKey: self.IsUserLoggedIn);
            completion( success )
        } )
    }
    
    public let IsUserLoggedIn = "isUserLoggedIn"
    
    
    
}
