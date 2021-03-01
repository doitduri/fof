import SwiftUI

struct ImageDetailView: View {
    let meme: MemeImage
    
    var body: some View {
        Image(meme.nickname)
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
//            .navigationBarTitle("Image \(imageName)")
    }
}
