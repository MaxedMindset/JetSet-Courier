import SwiftUI

/// Eine Minimap, die den Flugpositions-Punkt, das Ziel und eine Linie (Route) dazwischen anzeigt.
struct MinimapView: View {
    var flightPosition: CGPoint
    var destination: CGPoint
    // Skalierungsfaktor für die Minimap (Annahme: Weltkoordinaten sind groß, wir verkleinern sie)
    var scale: CGFloat = 0.1
    
    var body: some View {
        ZStack {
            // Hintergrund der Minimap (runder, halbtransparent)
            Circle()
                .fill(Color.black.opacity(0.7))
            // Route vom aktuellen Punkt zum Ziel (in gelb)
            Path { path in
                let center = CGPoint(x: 60, y: 60) // Mittelpunkt der Minimap (bei 120x120)
                let current = CGPoint(x: center.x + flightPosition.x * scale,
                                      y: center.y + flightPosition.y * scale)
                let dest = CGPoint(x: center.x + destination.x * scale,
                                   y: center.y + destination.y * scale)
                path.move(to: current)
                path.addLine(to: dest)
            }
            .stroke(Color.yellow, lineWidth: 2)
            // Aktuelle Position (blauer Punkt)
            Circle()
                .fill(Color.blue)
                .frame(width: 10, height: 10)
                .position(x: 60 + flightPosition.x * scale, y: 60 + flightPosition.y * scale)
            // Zielposition (roter Punkt)
            Circle()
                .fill(Color.red)
                .frame(width: 10, height: 10)
                .position(x: 60 + destination.x * scale, y: 60 + destination.y * scale)
        }
        .frame(width: 120, height: 120)
    }
}

struct MinimapView_Previews: PreviewProvider {
    static var previews: some View {
        MinimapView(flightPosition: CGPoint(x: 480, y: 480),
                    destination: CGPoint(x: 900, y: 900))
    }
}
