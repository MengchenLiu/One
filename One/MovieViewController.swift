//
//  SecondViewController.swift
//  One
//
//  Created by Mengchen Liu on 3/8/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

//View Controller for Movie view
class MovieViewController: UIViewController {
    @IBOutlet weak var MovieTextView: UITextView!

    let defaults = UserDefaults.standard
    let searchURL = "https://raw.githubusercontent.com/MengchenLiu/OneMockData/master/One_json.json"
    
    var pvc = AVPlayerViewController()
    var p = AVPlayer()
    
    @IBOutlet weak var MovieTitleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    //- Attribution:https://www.youtube.com/watch?v=bRhdFymK-eE
    //- Attribution:http://swiftdeveloperblog.com/code-examples/add-playback-slider-to-avplayer-example-in-swift/
    //play trailer of movie
    @IBAction func PlayVideo(_ sender: UIButton) {
        print("Play Trailer button is pressed")
        UIView.appearance().backgroundColor = UIColor(red: 255, green: 255, blue:255, alpha: 0)
        UIButton.appearance().backgroundColor = UIColor(red: 255, green: 255, blue:255, alpha: 0)
        
        let targetTime:CMTime = CMTimeMake(0, 1)
        self.pvc.player?.seek(to: targetTime)

        self.present(pvc,animated:true){
            self.pvc.player?.play()
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
                let mode = defaults.object(forKey: "mode") as? Bool ?? true
                CustomTabBarController.loadMode(mode)

    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //load data for movie view
    func resultHandler()->Void
    {
        print("resultHandler Excute!")
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.MovieTitleLabel.text = globalData.sharedData.movie_title
            
            var str = globalData.sharedData.movie_description
            str = str + "\n\nDirector:    " + globalData.sharedData.movie_director
            str = str + "\nWriter:    " + globalData.sharedData.movie_writer
            str = str + "\nGenre:    " + globalData.sharedData.movie_genre
            str = str + "\nRuntime:    " + globalData.sharedData.movie_runtime
            
            self.MovieTextView.text = str
            
            let img_url = URL(string: globalData.sharedData.movie_img)
            
            if NetReach.isConnectedToNetwork() == false{
                self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
            }
            let data = try? Data(contentsOf: img_url!)
            print("Load image from: \(globalData.sharedData.movie_img)")
            self.movieImageView.image = UIImage(data: data! )
            let fileURL = URL(string: globalData.sharedData.movieURL)
            //print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

            if NetReach.isConnectedToNetwork() == false{
                self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
            }
            self.p = AVPlayer(url:fileURL!)
            print("Load movie from: \(globalData.sharedData.movieURL)")
            self.pvc.player = self.p
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

