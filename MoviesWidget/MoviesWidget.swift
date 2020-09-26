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
    
    var body: some View{
        let movie = data.widgetData.shuffled().first
        
        if widgetFamily == .systemSmall {
            VStack{
                NetworkImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie?.imageURL ?? "")")!)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(5)
            }.edgesIgnoringSafeArea(.all)
                
        }
        else if widgetFamily == .systemLarge{
            VStack{
                NetworkImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie?.imageURL ?? "")")!)
                    .cornerRadius(5)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                Text("\(movie?.title ?? "")")
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                Text("\(movie?.releaseDate ?? "")")
                    .fontWeight(.medium)
                    .padding(.bottom,5)
                    .foregroundColor(Color.white)
                

            }
        }else if widgetFamily == .systemMedium {
            HStack{
                NetworkImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie?.imageURL ?? "")")!)
                    .cornerRadius(5)
                Text("\(movie?.title ?? "")")
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
            }.edgesIgnoringSafeArea(.all)
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
                    .background(Color.black.opacity(0.5))
                
            }
                
        }
        .configurationDisplayName("En Popüler Filmler Burada")
               .description("Üçünü de Dene Tarafını Seç")
        
        
    }
}

struct Provider: TimelineProvider{
    
    let widgetNetwork = WidgetNetwork()

    typealias Entry = Model
    
    func getSnapshot(in context: Context, completion: @escaping (Model) -> Void) {
        
        let loadingData = Model(date: Date(), widgetData: [JSONModel(title: "Movie Name", releaseDate: "06-06-2020", imageURL: "")])
        
        completion(loadingData)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Model>) -> Void) {
        widgetNetwork.getPopularMovies(page: 1) { (result) in
            let date = Date()
            let data = Model(date: date, widgetData: result.results ?? [])
            //print("data",data)
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: date)
            let timeline = Timeline(entries: [data], policy: .after(nextUpdate ?? Date()))
            completion(timeline)
        }
    }
    
    func placeholder(in context: Context) -> Model {
        let url = "https://image.tmdb.org/t/p/w500/kqjL17yufvn9OVLyXYpvtyrFfak.jpg"
        return Model(date: Date(), widgetData: [JSONModel(title: "Kerem", releaseDate: "Kerem", imageURL: url)])
    }
    
    
}

struct MovieWidget_Previews: PreviewProvider {
    static var previews: some View {
        Text("KEREM!")
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


