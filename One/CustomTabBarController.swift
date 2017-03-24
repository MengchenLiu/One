//
//  CustomTabBarController.swift
//  One
//
//  Created by Mengchen Liu on 3/11/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import UIKit

//- Attribution:http://stackoverflow.com/questions/36014073/make-custom-button-on-tab-bar-rounded
//This class manage the tabbar controller shared by 4 view controller. The info and mode button is implemented here
class CustomTabBarController: UITabBarController {
    
    
    @IBOutlet var InstructionView: UIView!

    @IBAction func disButton(_ sender: UIButton) {
        instructionDismiss()
    }
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NetReach.isConnectedToNetwork() == false{
            self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
        }
        else{
            let mode = defaults.object(forKey: "mode") as? Bool ?? true
            CustomTabBarController.loadMode(mode)
            setupInfoButton()
            setupModeButton()
            UserDefaults.standard.register(defaults: [String : Any]())
            
            //print the initial launch time
            // Attribution:https://www.youtube.com/watch?v=653muPqcPLA
            var time = defaults.object(forKey:"Initial Launch") as? NSDate ?? nil
            if(time == nil){
                time = NSDate()
                defaults.set(time, forKey: "Initial Launch")
                defaults.synchronize()
            }
            print("The first launch time is:")
            print(time ?? "")
        
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //pop a view of instruction
    func instructionIn(){
        print("Info button is pressed")
        UIView.animate(withDuration: 0.4, delay: 0.4, options: .curveEaseIn, animations:{},completion: nil)
        self.view.addSubview(InstructionView)
        InstructionView.center = self.view.center
        //InsructionView.center = self.view.center
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations:{},completion: nil)
    }
    
    //instrction view out
    //- Attribution: text book
    func instructionDismiss(){
        UIView.animate(withDuration: 0.3, animations:{}){(success:Bool) in self.InstructionView.removeFromSuperview()}

    }
    

    //add Info button to tabbar view
    func setupInfoButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 20, width: 60, height: 25))

        self.view.addSubview(button)
        

        button.setTitle("Info", for: UIControlState.normal)
        button.addTarget(self, action: #selector(instructionIn), for: UIControlEvents.touchUpInside)
        self.view.layoutIfNeeded()
    }
    
    //add Mode button to tabbar view
    func setupModeButton() {
        let button = UIButton(frame: CGRect(x: self.view.frame.width-60, y: 20, width: 60, height: 25))

        self.view.addSubview(button)
        
        button.setTitle("Mode", for: UIControlState.normal)
        button.addTarget(self, action: #selector(changeMode), for: UIControlEvents.touchUpInside)
        self.view.layoutIfNeeded()

    }
    
    //change the appearance of all view depend on night/day mode
    class func loadMode(_ night : Bool){
        if(night){
            UIView.appearance().backgroundColor = UIColor.gray
            UITextView.appearance().backgroundColor = UIColor.gray
            UIButton.appearance().backgroundColor = UIColor.gray
            UILabel.appearance().backgroundColor = UIColor(red: 0, green: 0, blue:0, alpha: 0)
            

            UITextView.appearance().textColor = UIColor.white
            UIButton.appearance().setTitleColor(UIColor.white, for: UIControlState.normal)
            UILabel.appearance().textColor = UIColor.white
            UIButton.appearance().tintColor = UIColor.white
            UITextView.appearance().tintColor = UIColor.white
        }else{
            
            UIView.appearance().backgroundColor = UIColor.white
            UITextView.appearance().backgroundColor = UIColor.white
            UIButton.appearance().backgroundColor = UIColor.white
            UILabel.appearance().backgroundColor = UIColor(red: 0, green: 0, blue:0, alpha: 0)
            
            UITextView.appearance().textColor = UIColor.gray
            UIButton.appearance().setTitleColor(UIColor.gray, for: UIControlState.normal)
            UILabel.appearance().textColor = UIColor.gray
            UIButton.appearance().tintColor = UIColor.gray
            UITextView.appearance().tintColor = UIColor.gray
        }
        
        let windows = UIApplication.shared.windows as [UIWindow]
        for window in windows {
            let subviews = window.subviews as [UIView]
            for v in subviews {
                v.removeFromSuperview()
                window.addSubview(v)
            }
        }

    }
    
    
    
    //change the mode when mode button is pressed
    func changeMode(){
        print("Change Mode button is pressed")
        let mode = defaults.object(forKey: "mode") as? Bool ?? true
        print(mode)
        
        //Night mode is true
        if(mode){
            defaults.set(false, forKey: "mode")
            defaults.synchronize()
            CustomTabBarController.loadMode(false)
            
        }
        else{
            defaults.set(true, forKey: "mode")
            defaults.synchronize()
            CustomTabBarController.loadMode(true)
        }
    }

    //show alert for specific information
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

    
    

}
