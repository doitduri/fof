import SwiftUI
import Grid
import WaterfallGrid

struct StaggeredGridView: View {
    
    @ObservedObject var memeFeed = MemeFeed()
    
    var message: String
    
    @State var showSettings: Bool = false
    @State var style = StaggeredGridStyle(.vertical, tracks: .count(2), spacing: 1)
//    @State var items: [Int] = (1...69).map { $0 }
    
    var body: some View {
        Text(message)
        NavigationView{
            ScrollView(style.axes) {
                Grid(memeFeed) { (memes: MemeImage) in
                    NavigationLink(destination: ImageDetailView(meme: memes)) {
                        UrlImageView(urlString: memes.imageUrl)
//                                .renderingMode(.original)
//                                .resizable()
                                
                }
                    
                .animation(.easeInOut)
                .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}

