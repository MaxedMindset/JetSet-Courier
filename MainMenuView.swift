//
//  MainMenuView.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//
//  Dieses Hauptmenü zeigt einen atmosphärischen Hintergrund, animierte Buttons und Navigation zu
//  den wichtigsten Bereichen des Spiels: Build Your Plane, Start Flight, Career Mode, Shop, Achievements etc.
//
import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("mainMenuBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // Ein dunkler Gradient-Overlay für bessere Lesbarkeit der Buttons
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    Text("SkyCraft: Build & Fly")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    NavigationLink(destination: BuildYourPlaneContainer().edgesIgnoringSafeArea(.all)) {
                        Text("Build Your Plane")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.green))
                            .shadow(radius: 8)
                    }
                    .padding(.horizontal, 40)
                    
                    NavigationLink(destination: StartFlightContainer().edgesIgnoringSafeArea(.all)) {
                        Text("Start Flight")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
                            .shadow(radius: 8)
                    }
                    .padding(.horizontal, 40)
                    
                    NavigationLink(destination: StorySceneView().edgesIgnoringSafeArea(.all)) {
                        Text("Career Mode")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.purple))
                            .shadow(radius: 8)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    Text("© 2025 SkyCraft Studios")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
