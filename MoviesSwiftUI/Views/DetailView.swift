//
//  DetailView.swift
//  FirstDemoSwiftUI
//
//  Created by Kerem on 21.09.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import Neumorphic

struct DetailView: View {
    @StateObject var network = Network()
    var moviesID: Int
    var movie: Movies
    var popularImage : String
    @EnvironmentObject var favorites : Favorites
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var body: some View {
        Neumorphic.shared.colorScheme = colorScheme
      return ZStack {
        LoadingView(isShowing: $network.isLoadingDetail)  {
            ScrollView{
                DetailMovieImage(detailImageMovie: network.detail)
                    .ignoresSafeArea(edges: .top)
                    //.frame(height: 300)

                CircleImage(image: popularImage)
                    .offset(y: -130)
                    .padding(.bottom, -150)

                VStack(alignment: .leading) {
                    HStack {
                        Text("\(network.detail?.title ?? "Unknown Title")")
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .font(.title)
                        Button(action: {
                            if self.favorites.contains(self.movie) {
                                self.favorites.remove(self.movie)
                            } else {
                                self.favorites.add(self.movie)
                            }
                            print(favorites.contains(movie))
                        }) {
                            Image(systemName: favorites.contains(movie) ? "star.fill" : "star")
                                .foregroundColor(favorites.contains(movie) ? Color.yellow : Color.gray)
                        }
                    }

                    HStack {
                        Text("\(network.detail?.tagline ?? "Unknown Tagline")")
                        Spacer()
                        //Text(landmark.state)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    Divider()

                    //Text("\(network.detail?.title ?? "Unknown Title")")
                    Text("DETAIL_ABOUT")
                        .font(.title2)
                    Text("\(network.detail?.overview ?? "Unknown Overview")")
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                }
                .padding()
                
                Button(action: {
                    guard let url = URL(string: "https://www.imdb.com/title/\(network.detail?.imdb_id ?? "")/") else { return }
                    UIApplication.shared.open(url)
                }) {
                    Text("Open in IMDB").fontWeight(.bold)
                }.softButtonStyle(RoundedRectangle(cornerRadius: 15))
            }
        }

            .onAppear{
                self.network.fetchDetails(chosenID: self.moviesID)
            }
            .navigationBarTitle(Text(network.detail?.title ?? ""), displayMode: .inline)
        }
    }
}

struct ButtonIMDB : View{
    var detailMovie : MovieDetail?
    var body: some View{
        VStack{
            Button(action: {
                guard let url = URL(string: "https://www.imdb.com/title/\(self.detailMovie?.imdb_id ?? "")/") else { return }
                UIApplication.shared.open(url)
            }) {
                Text("Open in IMDB")
                    .fontWeight(.bold)
                    .font(.headline)
                       .padding()
                       .background(Color.red)
                       .foregroundColor(.white)
                       .padding(3)
                       .border(Color.red, width: 1)
                
            }
        }
    }
}


struct DetailMovieImage : View{
    var detailImageMovie : MovieDetail?
    
    var body: some View {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(detailImageMovie?.imageURL ?? "")")
        VStack(alignment: .center, spacing: 0) {
            KFImage(url)
                .onSuccess { r in
                        // r: RetrieveImageResult
                        print("success: \(r)")
                    }

                    .placeholder {
                        // Placeholder while downloading.
                        Image(systemName: "arrow.2.circlepath.circle")
                            .font(.largeTitle)
                            .opacity(0.3)
                    }
                    //.frame(width: UIScreen.main.bounds.size.width - 20)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(3)
                .padding()
                    
        }
            
    }
}



struct FavoriteButton: View {
    @Binding var isSet: Bool

    var body: some View {
        Button(action: {
            isSet.toggle()
        }) {
            Image(systemName: isSet ? "star.fill" : "star")
                .foregroundColor(isSet ? Color.yellow : Color.gray)
        }
    }
}

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("LOADING_TEXT...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}
struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}




struct CircleImage: View {
    var image: String
    var width = UIScreen.main.bounds.width

    
    var body: some View {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(image)")
        KFImage(url)
            .onSuccess { r in
                    // r: RetrieveImageResult
                    print("success: \(r)")
                }

                .placeholder {
                    // Placeholder while downloading.
                    Image(systemName: "arrow.2.circlepath.circle")
                        .font(.largeTitle)
                        .opacity(0.3)
                }
            .resizable()
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .aspectRatio(contentMode: .fit)
            .frame(width:width/3)
            .shadow(radius: 7)
        
    }
}

