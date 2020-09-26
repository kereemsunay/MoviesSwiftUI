//
//  ContentView.swift
//  MoviesSwiftUI
//
//  Created by Kerem on 26.09.2020.
//



import SwiftUI
import Combine
import KingfisherSwiftUI


struct ContentView: View {
    
    @ObservedObject var network = Network()
    @State var page = 1
    
    var body: some View {
        
        NavigationView{
            
            List(network.movies){ movie in
                
                HStack {
                    NavigationLink(destination: DetailView(moviesID: movie.id ?? 0)) {
                        MovieImage(movies: movie)
                        MovieRowView(movies: movie)
                    }
                    
                }
            }
            .navigationBarItems(trailing: Button("Next"){
                self.page += 1
                self.network.fetchMovies(currentpage: self.page)
            })
                .navigationBarTitle("Movies")
        }
    }
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

