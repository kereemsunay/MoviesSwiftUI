//
//  MovieDetail.swift
//  FirstDemoSwiftUI
//
//  Created by Kerem on 19.09.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import Foundation

struct MovieDetail:Codable,Identifiable {
    let title: String?
    let overview : String?
    let imageURL : String?
    let id : Int
    let tagline: String?
    let genres:[Genres]?
    let imdb_id: String?
    let release_date:String?
    let vote_average:Double?
    
    enum CodingKeys : String, CodingKey {
        case overview,id,tagline,genres,title,imdb_id,release_date,vote_average
        case imageURL = "backdrop_path"
    }
}

struct Genres: Codable{
    let id: Int?
    let name: String?
}
