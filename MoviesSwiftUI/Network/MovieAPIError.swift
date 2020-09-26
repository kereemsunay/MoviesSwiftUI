//
//  MovieAPIError.swift
//  MoviesAPI
//
//  Created by Kerem on 23.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import Foundation

struct MovieAPIError: Codable, Error, LocalizedError {
    
    var statusMessage: String
    var statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_mesage"
        case statusCode = "status_code"
    }
    
    var localizedDescription: String {
        return statusMessage
    }
    
}
