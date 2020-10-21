//
//  RatingView.swift
//  MoviesSwiftUI
//
//  Created by Kerem on 21.10.2020.
//

import SwiftUI

struct StarsView: View {
    let rating: CGFloat
    let maxRating: CGFloat
    
    private let size: CGFloat = 14
    var body: some View {
        let text = HStack(spacing: 0) {
            ForEach(1..<11) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: size, height: size, alignment: .center)
            }
        }

        ZStack {
            text
            HStack(content: {
                GeometryReader(content: { geometry in
                    HStack(spacing: 0, content: {
                        let width1 = self.valueForWidth(geometry.size.width, value: rating)
                        let width2 = self.valueForWidth(geometry.size.width, value: (maxRating - rating))
                        Rectangle()
                            .frame(width: width1, height: geometry.size.height, alignment: .center)
                            .foregroundColor(.yellow)
                        
                        Rectangle()
                            .frame(width: width2, height: geometry.size.height, alignment: .center)
                            .foregroundColor(.gray)
                    })
                })
                .frame(width: size * maxRating, height: size, alignment: .trailing)
            })
            .mask(
                text
            )
        }
        .frame(width: size * maxRating, height: size, alignment: .leading)
    }
    
    func valueForWidth(_ width: CGFloat, value: CGFloat) -> CGFloat {
        value * width / maxRating
    }
}



struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        StarsView(rating: 8.0, maxRating: 10)
    }
}
