//
//  Network.swift
//  MoviesAPI
//
//  Created by Kerem on 10.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class Network :ObservableObject{
   // var didChange = PassthroughSubject<Network,Never>()
    var page = 1
    var chosenID: Int = 0
    @Published var movies = [Movies]()
    @Published var detail: MovieDetail?
    @Published var isLoadingDetail = true
    
   
    

    func getDataAPI<T: Decodable>(request:URLRequest , completion: @escaping ((Result<T,MovieAPIError>)-> Void)){
        

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async  {
                if let data = data {
                    
                    if let HTTPresponse = response as? HTTPURLResponse{
                        switch HTTPresponse.statusCode{
                        case 200:
                            do {
                                let result = try JSONDecoder().decode(T.self, from: data)
                                completion(.success(result))
                            } catch (let error) {
                                print(error)
                                completion(.failure(MovieAPIError(statusMessage: "Error", statusCode: 200)))
                            }
                            
                        case 400,401:
                            do {
                                let error = try JSONDecoder().decode(MovieAPIError.self, from: data)
                                completion(.failure(error))
                            } catch (let error) {
                                print(error)
                                completion(.failure(MovieAPIError(statusMessage: "Something went Wrong!", statusCode: HTTPresponse.statusCode)))
                            }
                            
                            
                        default:
                            completion(.failure(MovieAPIError(statusMessage: "Error response code", statusCode: HTTPresponse.statusCode)))
                        }
                        
                    }
                           }
            }
        }
        dataTask.resume()
        
    }
    
    func getPopularMovies(page:Int , completion: @escaping ((Result<PopularMovies,MovieAPIError>)-> Void)){
        let request = getPopularURL(page)
        getDataAPI(request: request, completion: completion)
    }
    
    func getMovieDetail(id:Int , completion: @escaping ((Result<MovieDetail,MovieAPIError>)-> Void)){
        let request = getDetailURL(id)
        getDataAPI(request: request, completion: completion)
    }
    

    
}

extension Network {
    
    func getPopularURL(_ page: Int) -> URLRequest {
        let lang = NSLocalizedString("NETWORK_LANG", comment: "Language changing")
        let api_key = "189d34686859866c672497d5d9a03707"
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(api_key)&language=\(lang)&page=\(page)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print("request",request)
        return request
    }
    //"https://api.themoviedb.org/3/movie/popular?api_key=189d34686859866c672497d5d9a03707&language=tr-TR&page=1"
    
    func getDetailURL(_ movie_id: Int) -> URLRequest {
        let lang = NSLocalizedString("NETWORK_LANG", comment: "Language changing")
        let api_key = "189d34686859866c672497d5d9a03707"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie_id)?api_key=\(api_key)&language=\(lang)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
}

extension Network{
    
//    func fetchMovies(currentpage: Int){
//        getPopularMovies(page: currentpage) { (result) in
//            switch result{
//            case .success(let movies):
//                print("currentpage",currentpage)
//                print("fetchMovies")
//                if let movie = movies.results{
//                    self.movies.append(contentsOf: movie)
//
//                }
//
//
//            case .failure(let error):
//                print("error",error)
//
//            }
//        }
//    }
    
    func fetchDetails(chosenID: Int){
        DispatchQueue.main.async {
            self.getMovieDetail(id: chosenID) { (result) in
                switch result{
                case .success(let details):
                    self.detail = details
                    self.isLoadingDetail = false
                case .failure(let error):
                    
                    print("error",error)
                }
            }
        }
        
    }
    
    
    
}

