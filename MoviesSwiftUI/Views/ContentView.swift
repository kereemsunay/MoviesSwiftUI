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
    @ObservedObject var favorites = Favorites()
    @State var isDonateActive = false
    
     var body: some View {
        NavigationView{
            ScrollView{
            ForEach(repos, id:\.id) { repo in
                HStack {
                    NavigationLink(destination: DetailView(moviesID: repo.id ?? 0, movie: repo, popularImage: repo.imageURL ?? ""
                    )) {
                        ZStack(alignment : .topTrailing){
                            MovieImage(movies: repo)
                                .padding()
                            if self.favorites.contains(repo) {
                                Spacer()
                                Image(systemName: "star.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.yellow)
                                    .padding(.trailing,15)
                                    .padding(.top,15)
                            }
                        }
                        //MovieRowView(movies: repo)
                        
                        
                    }
                    NavigationLink(destination: DonateView(), isActive: $isDonateActive){
                        EmptyView()
                    }
                }
                .onAppear {
                    favorites.getTaskIds()
//                    if self.repos.last == repo {
//                        //self.onScrolledAtBottom()
//                    }
                    
                }
            }
            .navigationBarTitle("MOVIE_LIST_BAR_TITLE")
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    
                    Button("MOVIE_LIST_TOOLBAR_BUTTON") {
                        isDonateActive.toggle()
                    }
                    
                    
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack{
                        Spacer()
                        Button("MOVIE_LIST_NEXT_PAGE") {
                            self.onScrolledAtBottom()
                        }
                        Spacer()
                        
                    }
                    
                    
                    
                }

            }
            
            
        }
        
        .environmentObject(favorites)
        
    }
    
    private var loadingIndicator: some View {
        Spinner(style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

struct MovieRowView : View{
    let movies : Movies
    
    var body: some View{
        VStack(alignment: .leading) {
            Text(movies.title)
                .font(.title)
                .fontWeight(.semibold)
            Text("\(movies.releaseDate ?? "NaN")")
                .font(.headline)
                .fontWeight(.medium)
            StarsView(rating: CGFloat(movies.voteAverage ?? 0.0)/2.0, maxRating: 5.0)
//            Text("\(movies.overview ?? "Nan")")
//                .italic()
//                .lineLimit(8)
            
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
            //.frame(width: 100)
            .cornerRadius(5)
        
    }
}



struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
