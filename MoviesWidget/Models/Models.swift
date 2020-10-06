//
//  Models.swift
//  MoviesWidgetExtension
//
//  Created by Kerem on 26.09.2020.
//

import Foundation

struct PopularMovies: Codable {
    var results : [JSONModel]?
    var page: Int?
}
struct JSONModel:Codable,Hashable {
    let title: String
    let vote_average: Double?
    let imageURL : String
    enum CodingKeys : String, CodingKey {
        case title,vote_average
        //case releaseDate = "release_date"
        case imageURL = "poster_path"
    }
}
