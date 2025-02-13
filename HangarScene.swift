import SwiftUI

struct HangarSceneView: View {
    // Statusvariablen zum Verfolgen der Position und des Status des Teils
    @State private var dragOffset: CGSize = .zero
    @State private var partAttached: Bool = false
    @State private var airplaneGlobalFrame: CGRect = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. Hangar-Hintergrund
                Image("hangarBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // 2. Flugzeug in der Mitte
                Image("airplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    // Erfasse den globalen Rahmen des Flugzeugs, um später Drops zu validieren
                    .background(
                        GeometryReader { airplaneGeo in
                            Color.clear
                                .onAppear {
                                    let frame = airplaneGeo.frame(in: .global)
                                    DispatchQueue.main.async {
                                        self.airplaneGlobalFrame = frame
                                    }
                                }
                                .onChange(of: airplaneGeo.frame(in: .global)) { newFrame in
                                    DispatchQueue.main.async {
                                        self.airplaneGlobalFrame = newFrame
                                    }
                                }
                        }
                    )
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                // 3. Das Flugzeugteil
                if partAttached {
                    // Wenn das Teil bereits angebracht ist, kann es weiter verschoben werden
                    Image("part1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .offset(dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.dragOffset = value.translation
                                }
                                .onEnded { value in
                                    self.dragOffset = value.translation
                                }
                        )
                } else {
                    // Zeige das Teil in einem Palette-Bereich (z. B. unten links)
                    Image("part1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .position(x: 100, y: geometry.size.height - 100)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.dragOffset = value.translation
                                }
                                .onEnded { value in
                                    // Berechne den neuen globalen Standort des Teils
                                    let startPosition = CGPoint(x: 100, y: geometry.size.height - 100)
                                    let dropPosition = CGPoint(
                                        x: startPosition.x + value.translation.width,
                                        y: startPosition.y + value.translation.height
                                    )
                                    
                                    // Prüfe, ob der Drop innerhalb des Flugzeugrahmens liegt
                                    if airplaneGlobalFrame.contains(dropPosition) {
                                        // Berechne den Offset relativ zur Mitte des Flugzeugs:
                                        let airplaneCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                        let relativeOffset = CGSize(
                                            width: dropPosition.x - airplaneCenter.x,
                                            height: dropPosition.y - airplaneCenter.y
                                        )
                                        self.dragOffset = relativeOffset
                                        self.partAttached = true
                                    } else {
                                        // Falls nicht in den Flugzeugbereich gezogen, zurücksetzen
                                        self.dragOffset = .zero
                                    }
                                }
                        )
                }
            }
        }
    }
}
