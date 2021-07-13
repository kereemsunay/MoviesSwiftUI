//
//  DonateView.swift
//  MoviesSwiftUI
//
//  Created by Kerem on 30.12.2020.
//

import SwiftUI
import KingfisherSwiftUI

struct DonateView: View {
    let colors: [Color] = [.red, .green, .blue]
    var body: some View {
        
        ScrollView{
            ForEach(colors, id: \.self) { color in
               DonateRow()
            }
            .navigationBarTitle(Text("MOVIE_LIST_TOOLBAR_BUTTON"),displayMode: .inline)
        }
    }
}

struct DonateView_Previews: PreviewProvider {
    static var previews: some View {
        DonateView()
    }
}
struct DonateRow:View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View{
        ZStack(alignment: .leading) {
            
            colorScheme == .dark ? Color.black : Color.white
            HStack {
                
                DonateImage(prizeImage: "prize.image")
                    .frame(width: UIScreen.main.bounds.width/2.75, height: 150, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text("Text")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .padding(.bottom, 5)
                    
                    Text("couponCode")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .padding(.bottom, 5)
                    
                    Text("Kupon Kodun")
                        .font(.caption)
                        .padding(.bottom, 5)
                        .foregroundColor(.gray)
                    
                }
                .padding(.horizontal, 5)
            }
            
            .padding(15)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.gray, radius: 3)
        .padding()
    }
}

struct DonateImage: View {
    var prizeImage : String
    var body: some View {
        let url = URL(string: "")
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
