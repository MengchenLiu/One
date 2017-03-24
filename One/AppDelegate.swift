//
//  AppDelegate.swift
//  One
//
//  Created by Mengchen Liu on 3/8/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //This method is used for a Launch View
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //- Attribution:http://stackoverflow.com/questions/5618163/displaying-splash-screen-for-longer-than-default-seconds
        
        window = UIApplication.shared.delegate!.window!
        
        let Image: UIImage = UIImage(named: "back")!
        
        let LaunchView=UIImageView(image: Image)
        LaunchView.frame =  CGRect(x: 0, y: 0, width:  (window?.frame.width)!,  height: (window?.frame.height)!)
        
        //the content of launch view
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 41))
        titleLabel.center = CGPoint(x:LaunchView.center.x, y: LaunchView.center.y-100)
        titleLabel.textAlignment = .center
        titleLabel.text = "One"
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: 10)
        LaunchView.addSubview( titleLabel)
        
        

        
        let authorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 41))
        authorLabel.center = CGPoint(x:LaunchView.center.x, y: LaunchView.center.y+150)
        authorLabel.textAlignment = .center
        authorLabel.text = "An App From Mengchen Liu"
        authorLabel.font = UIFont.systemFont(ofSize: 20, weight: 6)
        LaunchView.addSubview( authorLabel)
        
        
        window!.addSubview(LaunchView)
        window!.makeKeyAndVisible()
        
        //Adding splash Image as UIWindow's subview.
        window!.bringSubview(toFront: window!.subviews[0])
        
        delayWithSeconds(3) {
            // delayed code, by default run in main thread
            LaunchView.isHidden = true
        }
        if NetReach.isConnectedToNetwork() == false{
            self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
        }
        return true
    }
    
    //This method shows alert with specific information
    func showAlert(title:String, msg:String) {
        let alert = UIAlertController(title:title, message: msg, preferredStyle:.alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) -> Void in
            print("OK")
        }
        alert.addAction(ok)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true) { () -> Void in
            print("\(title)  Alert Pop Over!")
        }
    }
    
    //- Attribution:http://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}


