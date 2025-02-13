import SwiftUI

struct MainMenuScene: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrundbild (ersetze "mainMenuBackground" mit deinem Bildnamen)
                Image("mainMenuBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // App-Titel
                    Text("JetSet Courier")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    // Navigation-Buttons
                    NavigationLink(destination: HangarSceneView()) {
                        MenuButtonView(title: "Hangar")
                    }
                    
                    NavigationLink(destination: UpgradesScene()) {
                        MenuButtonView(title: "Upgrades")
                    }
                    
                    NavigationLink(destination: BuildYourPlanView()) {
                        MenuButtonView(title: "Bauplan")
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        // Sicherstellen, dass auf allen Geräten ein konsistenter Stil verwendet wird
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainMenuScene_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuScene()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}

// Wiederverwendbare Schaltflächen-View für das Menü
struct MenuButtonView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .frame(width: 250, height: 50)
            .background(Color.blue.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
