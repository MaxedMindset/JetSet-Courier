import SwiftUI

struct MultiplayerScene: View {
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrundbild
                Image("multiplayerBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Multiplayer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    if isSearching {
                        Text("Searching for opponents...")
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        Button(action: {
                            isSearching = true
                            // Simuliere eine Suche, die nach 3 Sekunden endet
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isSearching = false
                            }
                        }) {
                            MenuButtonView(title: "Find Match")
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Multiplayer", displayMode: .inline)
        }
    }
}

struct MultiplayerScene_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerScene()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}
