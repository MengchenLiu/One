//
//  FirstViewController.swift
//  One
//
//  Created by Mengchen Liu on 3/8/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import UIKit
import AVFoundation



//View Controller for music view
class MusicViewController: UIViewController {

    var musicPlayer:AVPlayer?
    var playerItem:AVPlayerItem?
    
    @IBOutlet weak var lyricsTextView: UITextView!
    @IBOutlet weak var MusicTitleLabel: UILabel!
    @IBOutlet weak var musicImageView: UIImageView!
     let searchURL = "https://raw.githubusercontent.com/MengchenLiu/OneMockData/master/One_json.json"
    
    @IBOutlet weak var Slider: UISlider!
    
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
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var PauseMusicButton: UIButton!
    
    //stop playing music
    @IBAction func StopMusicButton(_ sender: UIButton) {
        print("Stop button is pressed")
        musicPlayer?.pause()
        let targetTime:CMTime = CMTimeMake(0, 1)
        musicPlayer!.seek(to: targetTime)
        //PauseMusicButton.setTitle("Play", for: .normal)
        PauseMusicButton.setImage( UIImage(named: "Play Filled-50"), for: UIControlState.normal)
    }
    
    //replay music
    @IBAction func RestartButton(_ sender: UIButton) {
        print("Restart button is pressed")
        musicPlayer?.pause()
        let targetTime:CMTime = CMTimeMake(0, 1)
        musicPlayer!.seek(to: targetTime)
        musicPlayer?.play()
        //PauseMusicButton.setTitle("Pause", for: .normal)
            PauseMusicButton.setImage( UIImage(named: "Pause Filled-50"), for: UIControlState.normal)
    }
    
    //- Attribution:https://www.youtube.com/watch?v=Kq7eVJ6RSp8
    //- Attribution:https://www.youtube.com/watch?v=S3BSK8UVJyc
    //pause/start music
    @IBAction func PauseMusic(_ sender: UIButton) {
        print("Pause button is pressed")
        if(musicPlayer?.rate != 0){
            musicPlayer?.pause()
            //PauseMusicButton.setTitle("Play", for: .normal)
            PauseMusicButton.setImage( UIImage(named: "Play Filled-50"), for: UIControlState.normal)
        }
        else{
            musicPlayer?.play()
            //PauseMusicButton.setTitle("Pause", for: .normal)
            PauseMusicButton.setImage( UIImage(named: "Pause Filled-50"), for: UIControlState.normal)
        }
        
    }
    
    //use slider to change music time
    @IBAction func ChangeMusicTime(_ sender: UISlider) {
        print("Slider is dragged")
        musicPlayer?.pause()
        let targetTime:CMTime = CMTimeMake(Int64(Slider.value), 1)
        musicPlayer!.seek(to: targetTime)
        //musicPlayer.prepareToPlay()
        musicPlayer?.play()
        
        
    }
    
    @objc func updataSlider(){
        let cur : CMTime = musicPlayer!.currentTime()
        let seconds : Float64 = CMTimeGetSeconds(cur)
        
        Slider.value = Float(seconds)
        //NSLog
        
    }


    //load data need for loading view
    func resultHandler()->Void
    {
        print("resultHandler Excute!")

        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.MusicTitleLabel.text = globalData.sharedData.music_title
            
            let url1 = URL(string: globalData.sharedData.music_lyrics)
            
            if NetReach.isConnectedToNetwork() == false{
                self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
            }
            let data1 = try? Data(contentsOf: url1!)
            print("Load lyrics from: \(globalData.sharedData.music_lyrics)")
            let lyrics = String(data: data1!, encoding: String.Encoding.utf8)
            self.lyricsTextView.text = lyrics
            
            let img_url = URL(string: globalData.sharedData.music_img)
            if NetReach.isConnectedToNetwork() == false{
                self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
            }
            let data = try? Data(contentsOf: img_url!)
            print("Load image from: \(globalData.sharedData.music_img)")
            self.musicImageView.image = UIImage(data: data! )

            let url = URL(string: globalData.sharedData.musicURL)
            print(globalData.sharedData.musicURL)
            if NetReach.isConnectedToNetwork() == false{
                self.showAlert( title: "Connect Error",msg: "Something wrong with network...")
            }
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            print("Load music from: \(globalData.sharedData.musicURL)")
            self.musicPlayer = AVPlayer(playerItem: playerItem)
            
            let playerLayer=AVPlayerLayer(player: self.musicPlayer!)
            playerLayer.frame=CGRect(x:0, y:0, width:10, height:50)
            self.view.layer.addSublayer(playerLayer)
            
            let duration : CMTime = playerItem.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            self.Slider.maximumValue = Float(seconds)
            
            
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updataSlider), userInfo: nil, repeats: true)
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

