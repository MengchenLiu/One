//
//  Data.swift
//  One
//
//  Created by Mengchen Liu on 3/8/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import Foundation
import UIKit

//This class stores the data read from API ,include short desciption and image url
class globalData {
    
    
    static let sharedData = globalData()
    private init() {}

    
    //Article
    var articleURL = ""
    var article_imgURL = ""
    var article_title = ""
    
    
    
    //Music
    var music_img = ""
    var musicURL = ""
    var music_title = ""
    var music_lyrics = ""
    
    //Picture
    var imageURL = ""
    var image_title = ""
    var image_description = ""
    
    
    //Movie
    var movieURL = ""
    var movie_img = ""
    var movie_title = ""
    var movie_description = ""
    var movie_director = ""
    var movie_genre = ""
    var movie_writer = ""
    var movie_runtime = ""
    
    
}
