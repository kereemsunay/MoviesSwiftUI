//
//  PopularMovies.swift
//  FirstDemoSwiftUI
//
//  Created by Kerem on 19.09.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import Foundation

struct Movies:Codable, Identifiable {
    let title: String
    let releaseDate: String?
    let overview : String?
    let imageURL : String?
    let id : Int?
    let voteAverage:Double?
    
    enum CodingKeys : String, CodingKey {
        case title,overview,id
        case releaseDate = "release_date"
        case imageURL = "poster_path"
        case voteAverage = "vote_average"
    }
}
struct PopularMovies: Codable {
    var results : [Movies]?
    var page: Int?
}
