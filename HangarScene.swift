import SwiftUI

struct HangarSceneView: View {
    // Statusvariablen für die einzelnen Komponenten
    @State private var hullAttached: Bool = false
    @State private var hullOffset: CGSize = .zero

    @State private var wingAttached: Bool = false
    @State private var wingOffset: CGSize = .zero

    @State private var tailAttached: Bool = false
    @State private var tailOffset: CGSize = .zero

    @State private var landingGearAttached: Bool = false
    @State private var landingGearOffset: CGSize = .zero

    @State private var engineAttached: Bool = false
    @State private var engineOffset: CGSize = .zero

    // Erfasste Position der zentralen Drop-Zone (Flugzeugzentrum)
    @State private var airplaneCenter: CGPoint = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. Hangar-Hintergrund
                Image("hangarBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                // 2. Top-Bar (Level, Geld, Ranglistenplatz)
                TopBarView(level: "Level 1", money: "$1000", rank: "Platz 5")
                    .position(x: geometry.size.width/2, y: 40)

                // 3. Zentrale Drop-Zone (als Umriss angezeigt)
                ZStack {
                    // Drop-Zone-Kontur (optional)
                    Circle()
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(width: 200, height: 200)
                        .opacity(0.5)

                    // Angeheftete Komponenten werden hier relativ zur Mitte angezeigt

                    if hullAttached {
                        Image("hull")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .offset(hullOffset)
                    }
                    if wingAttached {
                        Image("wing")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .offset(wingOffset)
                    }
                    if engineAttached {
                        Image("engine")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .offset(engineOffset)
                    }
                    if landingGearAttached {
                        Image("landingGear")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .offset(landingGearOffset)
                    }
                    if tailAttached {
                        Image("tail")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .offset(tailOffset)
                    }
                }
                // Zentriere die Drop-Zone
                .position(x: geometry.size.width/2, y: geometry.size.height/2)
                // Ermittle die Mitte der Drop-Zone
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                airplaneCenter = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
                            }
                    }
                )

                // 4. Palette der Bauteile (unten)
                VStack {
                    Spacer()
                    HStack(spacing: 20) {
                        // Rumpf (Hauptstruktur)
                        DraggablePartView(
                            imageName: "hull",
                            targetOffset: .zero,  // Ziel: exakt in der Mitte
                            initialPosition: CGPoint(x: 60, y: geometry.size.height - 60),
                            attached: $hullAttached,
                            dragOffset: $hullOffset,
                            airplaneCenter: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                        )

                        // Flügel (links vom Zentrum)
                        DraggablePartView(
                            imageName: "wing",
                            targetOffset: CGSize(width: -100, height: 0),
                            initialPosition: CGPoint(x: 140, y: geometry.size.height - 60),
                            attached: $wingAttached,
                            dragOffset: $wingOffset,
                            airplaneCenter: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                        )

                        // Motor (vorderer Bereich, oben)
                        DraggablePartView(
                            imageName: "engine",
                            targetOffset: CGSize(width: 0, height: -100),
                            initialPosition: CGPoint(x: 220, y: geometry.size.height - 60),
                            attached: $engineAttached,
                            dragOffset: $engineOffset,
                            airplaneCenter: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                        )

                        // Fahrwerk (unterhalb des Zentrums)
                        DraggablePartView(
                            imageName: "landingGear",
                            targetOffset: CGSize(width: 0, height: 50),
                            initialPosition: CGPoint(x: 300, y: geometry.size.height - 60),
                            attached: $landingGearAttached,
                            dragOffset: $landingGearOffset,
                            airplaneCenter: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                        )

                        // Leitwerk (hinten, z. B. am Heck)
                        DraggablePartView(
                            imageName: "tail",
                            targetOffset: CGSize(width: 0, height: 100),
                            initialPosition: CGPoint(x: 380, y: geometry.size.height - 60),
                            attached: $tailAttached,
                            dragOffset: $tailOffset,
                            airplaneCenter: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                        )
                    }
                    .padding(.bottom, 20)
                }

                // 5. Bauplan-Button in der unteren rechten Ecke
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Aktion beim Tippen auf den Bauplan (z. B. Navigation zu Detailansicht)
                        }) {
                            Image("bauplan")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct HangarSceneView_Previews: PreviewProvider {
    static var previews: some View {
        HangarSceneView()
    }
}
