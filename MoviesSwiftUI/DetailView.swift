//
//  DetailView.swift
//  FirstDemoSwiftUI
//
//  Created by Kerem on 21.09.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        DetailView()
        
    }
}

struct DetailView: View {
    
    @ObservedObject var network = Network()
    var moviesID: Int?
    
    
    var body: some View {
        
            VStack {
                DetailMovieDesign(detailMovie: network.detail)
               
                    
                }.onAppear{
                    self.network.fetchDetails(chosenID: self.moviesID ?? 0)
            }
            
        
    }
}
struct DetailMovieDesign : View{
    var detailMovie : MovieDetail?
    
    var body: some View{
        
            VStack {
                DetailMovieImage(detailImageMovie: detailMovie)
                DetailMovieLabels(detailMovie: detailMovie)
                Spacer()
                Spacer()
                ButtonIMDB(detailMovie: detailMovie)
                
            }.padding()
            
           
        
    }
}

struct DetailMovieLabels : View{
    var detailMovie : MovieDetail?
    
    var body: some View{
        VStack(alignment:.leading){
            Text("\(detailMovie?.title ?? "Kerrrem")")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom,10)
                
            Text("\(detailMovie?.tagline ?? "Tagline")")
                .padding(.bottom,5)
                .foregroundColor(Color.white)
                .background(Color.red)
            ScrollView{
                Text("\(detailMovie?.overview ?? "askkldfsdlkfsdjlfkjsdfsss")")
                .fixedSize(horizontal: false, vertical: true)
            }
                
           
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
                .frame(width: UIScreen.main.bounds.size.width - 20)
                .cornerRadius(3)
            
    }
}

