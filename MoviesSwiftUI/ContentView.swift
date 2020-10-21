//
//  ContentView.swift
//  MoviesSwiftUI
//
//  Created by Kerem on 26.09.2020.
//



import SwiftUI
import Combine
import KingfisherSwiftUI



struct RepositoriesListContainer: View {
    @ObservedObject var viewModel: RepositoriesViewModel
    
    var body: some View {
        MovieList(
            repos: viewModel.state.repos,
            isLoading: viewModel.state.canLoadNextPage,
            onScrolledAtBottom: viewModel.fetchNextPageIfPossible
        )
        .onAppear(perform: viewModel.fetchNextPageIfPossible)
    }
}



struct MovieList: View {
    let repos: [Movies]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
    
    var body: some View {
        NavigationView{
            List {
                reposList
                if isLoading {
                    loadingIndicator
                }
            }.navigationBarTitle("Movies")
        }
    }
    
    private var reposList: some View {
        ForEach(repos) { repo in
            HStack {
                NavigationLink(destination: DetailView(moviesID: repo.id ?? 0)) {
                    MovieImage(movies: repo)
                    MovieRowView(movies: repo)
                }
                
            }.onAppear {
                if self.repos.last == repo {
                    self.onScrolledAtBottom()
                }
            }
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

//MARK -> Components
struct MovieRowView : View{
    let movies : Movies
    
    var body: some View{
        VStack(alignment: .leading) {
            Text(movies.title)
                .font(.title)
                .fontWeight(.bold)
            Text("\(movies.releaseDate ?? "NaN")")
                .font(.headline)
                .fontWeight(.medium)
            Text("\(movies.overview ?? "Nan")")
                .italic()
                .lineLimit(8)
            
        }
    }
}
struct MovieImage : View{
    let movies : Movies
    var body: some View {
       
        KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(movies.imageURL ?? "")")!)
            .onSuccess { r in
              
               }
               .placeholder {
                   // Placeholder while downloading.
                   Image(systemName: "arrow.2.circlepath.circle")
                       .font(.largeTitle)
                       .opacity(0.3)
               }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(5)
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

