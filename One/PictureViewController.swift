//
//  PictureViewController.swift
//  One
//
//  Created by Mengchen Liu on 3/9/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import Foundation
import UIKit

//View Controller for Picture view
class PictureViewController: UIViewController ,UIScrollViewDelegate{
    let searchURL = "https://raw.githubusercontent.com/MengchenLiu/OneMockData/master/One_json.json"
    
    
    @IBOutlet weak var ImageDesTextView: UITextView!
    @IBOutlet weak var ImageTitleLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    var fullScreenView : UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    }
    
    //tap the image show it full screen
    func handleTap(recognizer:UITapGestureRecognizer){
        print("Picture is Tapped")
        let imgView = UIImageView(image: myImageView.image)
        fullScreenView = UIScrollView()
        fullScreenView.frame = self.view.frame
        imgView.frame = self.view.frame
        fullScreenView.backgroundColor = .black
        fullScreenView.minimumZoomScale = 1.0
        fullScreenView.maximumZoomScale = 6.0
        fullScreenView.delegate = self
        //fullScreenView.contentMode = .scaleAspectFit
        fullScreenView.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer(target: self,
                                                 action: #selector(self.dismissFullscreen))
        
        fullScreenView.addGestureRecognizer(tapGesture1)
        self.view.addSubview(fullScreenView)
        self.fullScreenView.addSubview(imgView)
    }
    
    
    
    //dismiss fullscreen
    func dismissFullscreen(recognizer: UITapGestureRecognizer) {
        fullScreenView.removeFromSuperview()
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.fullScreenView
    }
    
    //load data need for picture view
    func resultHandler()->Void
    {
        print("resultHandler Excute!")
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            self.ImageTitleLabel.text = globalData.sharedData.image_title
            self.ImageDesTextView.text = globalData.sharedData.image_description
            let url = URL(string: globalData.sharedData.imageURL)
            
            if NetReach.isConnectedToNetwork() == false{
                self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
            }
            let data = try? Data(contentsOf: url!)
            print("Load image from: \(globalData.sharedData.imageURL)")

            self.myImageView.image = UIImage(data: data! )
            
            self.myImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(self.handleTap))
            
            self.myImageView.addGestureRecognizer(tapGesture)
            
            
        }
        
    }
    func showAlert(title:String, msg:String) {
        let alert = UIAlertController(title:title, message: msg, preferredStyle:.alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) -> Void in
            print("OK")
        }
        alert.addAction(ok)
        self.present(alert, animated: true) { () -> Void in
            print("\(title)  Alert Pop Over!")
        }
    }
    
    
    
}

