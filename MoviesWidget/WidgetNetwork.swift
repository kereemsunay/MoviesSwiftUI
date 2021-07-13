//
//  WidgetNetwork.swift
//  MovieWidgetExtension
//
//  Created by Kerem on 26.09.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//


import Foundation
import Combine

class WidgetNetwork {

    
    func getDataAPI(request:URLRequest , completion: @escaping (PopularMovies)-> Void){
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async  {
                if let data = data {
                   
                    do {
                        let result = try JSONDecoder().decode(PopularMovies.self, from: data)
                        completion(result)
                    } catch (let error) {
                        print("girdi")
                        print(error.localizedDescription)
                    }
                }
            }
        }
        dataTask.resume()
        
    }
    func getPopularMovies(page:Int , completion: @escaping (PopularMovies)-> Void){
        let request = getPopularURL(page)
        getDataAPI(request: request, completion: completion)
        
    }


    
}

extension WidgetNetwork {
    
    func getPopularURL(_ page: Int) -> URLRequest {
        let lang = NSLocalizedString("NETWORK_LANG", comment: "Language changing")
        let api_key = "189d34686859866c672497d5d9a03707"
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(api_key)&language=\(lang)&page=\(page)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    
}


