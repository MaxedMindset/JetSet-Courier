import SwiftUI

struct MainMenuScene: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrundbild
                Image("mainMenuBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Text("JetSet Courier")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    NavigationLink(destination: BuildYourPlaneView()) {
                        MenuButtonView(title: "Build Your Plane")
                    }
                    
                    NavigationLink(destination: MultiplayerScene()) {
                        MenuButtonView(title: "Multiplayer")
                    }
                    
                    NavigationLink(destination: ReplayScene()) {
                        MenuButtonView(title: "Replay")
                    }
                    
                    NavigationLink(destination: CosmeticScene()) {
                        MenuButtonView(title: "Cosmetics")
                    }
                    
                    NavigationLink(destination: ShopScene()) {
                        MenuButtonView(title: "Shop")
                    }
                    
                    NavigationLink(destination: StoryScene()) {
                        MenuButtonView(title: "Story Mode")
                    }
                    
                    NavigationLink(destination: SettingsScene()) {
                        MenuButtonView(title: "Settings")
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainMenuScene_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuScene()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}

// Wiederverwendbare Menü-Schaltfläche
struct MenuButtonView: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(width: 250, height: 50)
            .background(Color.blue.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

