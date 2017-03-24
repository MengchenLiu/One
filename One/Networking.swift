//
//  Networking.swift
//  One
//
//  Created by Mengchen Liu on 3/8/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import Foundation
import UIKit

//custom ErrorType
enum UserError : Error{
    case NoNetwork
}

//handle the URLSession task, read data from API
class Networking{

    static let sharedInstance = Networking() // use this property to access the shared instance of the class
    
    private init() {} // make the initializer private so that no other instances can be created
    
    func get_data(_ add:String?, _ completionHandler: (() -> Void)?) throws {
        
        
        guard NetReach.isConnectedToNetwork()==true else {
            throw UserError.NoNetwork
        }
        
        //- Attribution:https://www.ioscreator.com/tutorials/display-activity-indicator-status-bar-ios8-swift
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let defaultConfiguration = URLSessionConfiguration.default
        
        let sessionWithoutADelegate = URLSession(configuration: defaultConfiguration)
        print("Read data from: \(add!)")
        let url = URL(string: add!)
        
        let task = sessionWithoutADelegate.dataTask(with: url!){
            (data, response, error) in
            if error != nil {
                
                print("Error: \(error)")
            } else if let _ = response,
                let data = data,
                let _ = String(data: data, encoding: .utf8) {
                
                self.updateSearchResults(data)
                completionHandler!()
            }
            else{
                
                fatalError("error was nil, but no data. This should never happen")
            }
            
        }
        task.resume()
    }
    
    //parse the data read from task,update them in globalData
    func updateSearchResults(_ data: Data?) {
        do {
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [[String: Any]]{
                    for res in json{
                        if let article = res["article_url"] as? String,
                            let article_img = res["article_img_url"] as? String,
                            let article_title = res["article_title"] as? String,
                            let music = res["musicURL"] as? String,
                            let music_img = res["music_img"] as? String,
                            let music_title = res["music_title"] as? String,
                            let music_lyrics = res["music_lyrics"] as? String,
                            let Image = res["image_url"] as? String,
                            let image_title = res["image_title"] as? String,
                            let image_description = res["image_description"] as? String,
                            let movie = res["movieURL"] as? String,
                            let movie_img = res["movie_img"] as? String,
                            let movie_title = res["movie_title"] as? String,
                            let movie_description = res["movie_description"] as? String,
                            let movie_director = res["movie_director"] as? String,
                            let movie_genre = res["movie_genre"] as? String,
                            let movie_writer = res["movie_writer"] as? String,
                            let movie_runtime = res["movie_runtime"] as? String {

                            globalData.sharedData.articleURL = article
                            globalData.sharedData.article_imgURL = article_img
                            globalData.sharedData.article_title = article_title
                            
                            globalData.sharedData.musicURL = music
                            globalData.sharedData.music_img = music_img
                            globalData.sharedData.music_title = music_title
                            globalData.sharedData.music_lyrics = music_lyrics
                            
                            globalData.sharedData.imageURL = Image
                            globalData.sharedData.image_title = image_title
                            globalData.sharedData.image_description = image_description
                            
                            globalData.sharedData.movieURL = movie
                            globalData.sharedData.movie_title = movie_title
                            globalData.sharedData.movie_img = movie_img
                            globalData.sharedData.movie_description = movie_description
                            globalData.sharedData.movie_director = movie_director
                            globalData.sharedData.movie_writer = movie_writer
                            globalData.sharedData.movie_genre = movie_genre
                            globalData.sharedData.movie_runtime = movie_runtime
                            
                            
                        }else{
                            print("Not a dictionary")
                        }
                    }
            } else {
                print("Results key not found in dictionary")
            }
        }
    }
    
}
