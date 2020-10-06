//
//  MoviesWidget.swift
//  MoviesWidget
//
//  Created by Kerem on 26.09.2020.
//

import WidgetKit
import SwiftUI



struct Model: TimelineEntry {
    var date : Date
    var widgetData : [JSONModel]
}


struct WidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var data : Provider.Entry
    
    let numberFormatter: NumberFormatter = {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 10
        return numberFormatter
    }()
    
    var body: some View{
        let movie = data.widgetData.shuffled().first
        
        switch widgetFamily {
        case .systemLarge:
            VStack{
                NetworkImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie?.imageURL ?? "")")!)
                    .cornerRadius(5)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                Text("\(movie?.title ?? "")")
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                Text("Rating: \(movie?.vote_average ?? 0.0)")
                    .fontWeight(.medium)
                    .padding(.bottom,5)
                    .foregroundColor(Color.white)
            }
        case .systemSmall:
            VStack{
                NetworkImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie?.imageURL ?? "")")!)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(5)
            }.edgesIgnoringSafeArea(.all)
        case .systemMedium:
            VStack{
                Text("\(movie?.title ?? "")")
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                Text("Rating: \(movie?.vote_average ?? 0.0)")
                    .fontWeight(.medium)
                    .padding(.bottom,5)
                    .foregroundColor(Color.white)
            }
        @unknown default:
            Text("\(movie?.vote_average ?? 0.0)")
                .fontWeight(.medium)
                .padding(.bottom,5)
                .foregroundColor(Color.white)
        }
        
    }
}

@main
struct MainWidget:Widget {
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: "any identitfer..", provider: Provider()) {data in
            VStack{
                WidgetView(data: data)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.8))
                
            }
                
        }
        .configurationDisplayName("En Popüler Filmler Burada")
        .description("Üçünü de Dene Tarafını Seç")
        .supportedFamilies([.systemSmall,.systemLarge])
        
    }
}

struct Provider: TimelineProvider{
    
    let widgetNetwork = WidgetNetwork()

    typealias Entry = Model
    
    func getSnapshot(in context: Context, completion: @escaping (Model) -> Void) {
        
        let loadingData = Model(date: Date(), widgetData: [JSONModel(title: "Movie Name", vote_average: 0.0, imageURL: "")])
        
        completion(loadingData)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Model>) -> Void) {
        widgetNetwork.getPopularMovies(page: 1) { (result) in
            let date = Date()
            let data = Model(date: date, widgetData: result.results ?? [])
            //print("data",data)
            //let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: date)
            let timeline = Timeline(entries: [data], policy: .atEnd)
            completion(timeline)
        }
    }
    
    func placeholder(in context: Context) -> Model {
        return Model(date: Date(), widgetData: [JSONModel(title: "Movie Name", vote_average: 0.0, imageURL: "")])
    }
    
    
}

struct MovieWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            WidgetView(data: Model(date: Date(), widgetData: [JSONModel(title: "Movie Name", vote_average: 0.0, imageURL: "")]))
                .padding(.vertical)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small widget")
                .environment(\.colorScheme, .dark)
            WidgetView(data: Model(date: Date(), widgetData: [JSONModel(title: "Movie Name", vote_average: 0.0, imageURL: "")]))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .previewDisplayName("Large widget")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                
        }
        

    }
}
struct NetworkImage: View {
    let url: URL?
    var body: some View {
        Group {
            if let url = url, let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            }
            else {
                VStack{
                    Image("BG")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                }
                
      }
    }
  }

}


