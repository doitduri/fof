import SwiftUI
import WaterfallGrid

struct ContentView: View {
    var body: some View {
        NavigationView{
            NavigationLink(destination: LoginView()) {
                HStack {
                    Text("main Grid")
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
