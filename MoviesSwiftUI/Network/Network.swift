//
//  Network.swift
//  MoviesAPI
//
//  Created by Kerem on 10.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import Foundation
import Combine

class Network :ObservableObject{
    var didChange = PassthroughSubject<Network,Never>()
    var page = 1
    var chosenID: Int = 0
    @Published var movies = [Movies](){
        didSet{
            didChange.send(self)
        }
    }
   @Published var detail: MovieDetail?{
       didSet{
            didChange.send(self)
       }
   }

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
    
    init() {
           fetchMovies(currentpage: page)
        
       }
    
}

extension Network {
    
    func getPopularURL(_ page: Int) -> URLRequest {
        let api_key = "189d34686859866c672497d5d9a03707"
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(api_key)&page=\(page)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func getDetailURL(_ movie_id: Int) -> URLRequest {
        let api_key = "189d34686859866c672497d5d9a03707"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie_id)?api_key=\(api_key)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
}
extension Network{
    
    func fetchMovies(currentpage: Int){
        getPopularMovies(page: currentpage) { (result) in
            switch result{
            case .success(let movies):
                print("fetchMovies")
                if let movie = movies.results{
                    self.movies.append(contentsOf: movie)
                    print(self.movies.count)
                }
                
                
            case .failure(let error):
                print("error",error)
                
            }
        }
    }
    func fetchDetails(chosenID: Int){
        getMovieDetail(id: chosenID) { (result) in
            switch result{
            case .success(let details):
                self.detail = details
            case .failure(let error):
                
                print("error",error)
            }
        }
        
    }
    
    
    
}

