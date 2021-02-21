import SwiftUI
import Grid
import WaterfallGrid

struct StaggeredGridView: View {
    
    var message: String
    
    @State var showSettings: Bool = false
    @State var style = StaggeredGridStyle(.vertical, tracks: .count(2), spacing: 1)
    @State var items: [Int] = (1...69).map { $0 }
    
    var body: some View {
        Text(message)
        NavigationView{
            ScrollView(style.axes) {
                Grid(self.items, id: \.self) { index in
                    NavigationLink(destination: ImageDetailView(imageName: "\(index)")) {
                        Image("\(index)")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .animation(.easeInOut)
                .edgesIgnoringSafeArea(.all)
            }
        }
        
//        .navigationBarTitle("Grid", displayMode: .inline)
//        .navigationBarItems(trailing:
//            HStack {
//                Button(action: { self.shuffleImages() }) {
//                    Text("Shuffle")
//                }
//
//                Button(action: { self.showSettings = true }) {
//                    Image(systemName: "gear")
//                }
//            }

//        )
//        .sheet(isPresented: $showSettings) {
//            StaggeredGridSettingsView(style: self.$style).accentColor(.purple)
//
//        }
        .gridStyle(
            self.style
        )
    }
    
    func shuffleImages() {
        self.items.shuffle()
    }
}

