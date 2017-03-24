//
//  ArticleViewController.swift
//  One
//
//  Created by Mengchen Liu on 3/8/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import UIKit

//ViewController for article view
class ArticleViewController: UIViewController {

    
    @IBOutlet weak var ArticleTitleLabel: UILabel!
    @IBOutlet weak var textfield: UITextView!
        let searchURL = "https://raw.githubusercontent.com/MengchenLiu/OneMockData/master/One_json.json"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NetReach.isConnectedToNetwork() == false{
            self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
        }
        do{
            try Networking.sharedInstance.get_data(searchURL, resultHandler)
        }catch UserError.NoNetwork{
            self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
        }catch{
            print("some other errors")
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //use data read from API to load the view
    func resultHandler()->Void
    {
        print("resultHandler Excute!")

        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            
            let url = URL(string: globalData.sharedData.articleURL)

            if NetReach.isConnectedToNetwork() == false{
                self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
            }
            let data1 = try? Data(contentsOf: url!)
            print("Load text from: \(globalData.sharedData.articleURL)")
            let textFile = String(data: data1!, encoding: String.Encoding.utf8)
            
            
            self.ArticleTitleLabel.text = globalData.sharedData.article_title
            let attributedString = NSMutableAttributedString(string: "......   \(textFile!)")
            let textAttachment = NSTextAttachment()
            let url1 = URL(string: globalData.sharedData.article_imgURL)
            if NetReach.isConnectedToNetwork() == false{
                self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
            }
            let data = try? Data(contentsOf: url1!)
            print("Load image from: \(globalData.sharedData.article_imgURL)")
            textAttachment.image = UIImage(data: data!)
            
            let oldWidth = textAttachment.image!.size.width;
            
            
            //- Attribution:http://stackoverflow.com/questions/24010035/how-to-add-image-and-text-in-uitextview-in-ios
            
            let scaleFactor = oldWidth / (self.textfield.frame.size.width - 10);
            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
            attributedString.replaceCharacters(in: NSMakeRange(6, 1), with: attrStringWithImage)
            self.textfield.attributedText = attributedString;
            
        }
        
    }
    
    func showAlert(title:String, msg:String) {
        UIView.appearance().backgroundColor = UIColor(red: 0, green: 0, blue:0, alpha: 0)
        let alert = UIAlertController(title:title, message: msg, preferredStyle:.alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) -> Void in
            print("OK")
            let defaults = UserDefaults.standard
            let mode = defaults.object(forKey: "mode") as? Bool ?? true
            CustomTabBarController.loadMode(mode)
        }
        alert.addAction(ok)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true) { () -> Void in
            print("\(title)  Alert Pop Over!")
        }
    }
    

}



