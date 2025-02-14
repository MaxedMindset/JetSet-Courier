import SwiftUI

struct CosmeticScene: View {
    @State private var selectedSkin: String = "Default"
    let availableSkins = ["Default", "Red", "Blue", "Green"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrundbild
                Image("cosmeticBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Cosmetics")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                    
                    // Horizontale Auswahl der Skins
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(availableSkins, id: \.self) { skin in
                                Button(action: {
                                    selectedSkin = skin
                                }) {
                                    Image(skin) // Asset-Name entspricht dem Skin-Namen
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .border(selectedSkin == skin ? Color.yellow : Color.clear, width: 3)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Cosmetics", displayMode: .inline)
        }
    }
}

struct CosmeticScene_Previews: PreviewProvider {
    static var previews: some View {
        CosmeticScene()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}
