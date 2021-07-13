//
//  ViewModel.swift
//  MoviesSwiftUI
//
//  Created by Kerem on 21.10.2020.
//

import Foundation

class RepositoriesViewModel: ObservableObject {
    struct State {
        var repos: [Movies] = []
        var page: Int = 1
        var canLoadNextPage = true
    }
    @Published var query = ""
    
    @Published private(set) var state = State()

    func fetchNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        
        Network().getPopularMovies(page: state.page) { (result) in
            switch result{
            case .success(let movies):
                if let movie = movies.results{
                    self.state.repos.append(contentsOf: movie)
                    print(self.state.repos.count)
                }
            case .failure(let error):
                print("error",error)
                
            }
        }
        print("state.page",state.page)
        state.page += 1
    }
    
}
