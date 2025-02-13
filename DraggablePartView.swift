import SwiftUI

struct DraggablePartView: View {
    let imageName: String
    let targetOffset: CGSize      // Zielposition relativ zur Mitte der Drop-Zone
    let initialPosition: CGPoint  // Startposition in der Palette
    @Binding var attached: Bool   // Ob das Teil bereits angebracht wurde
    @Binding var dragOffset: CGSize
    let airplaneCenter: CGPoint   // Mitte der zentralen Drop-Zone

    // Hilfsfunktion: Abstand zwischen zwei Punkten berechnen
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        let dx = from.x - to.x
        let dy = from.y - to.y
        return sqrt(dx * dx + dy * dy)
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            // Wenn angebracht, wird die Komponente an der Mitte (plus Offset) positioniert,
            // ansonsten am initialen Ort in der Palette
            .position(attached ? airplaneCenter : initialPosition)
            .offset(attached ? dragOffset : dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        // Bestimme die Drop-Position
                        let dropPosition = CGPoint(
                            x: initialPosition.x + value.translation.width,
                            y: initialPosition.y + value.translation.height
                        )
                        // Wird das Teil nahe genug an der Drop-Zone (Mitte) abgelegt?
                        if distance(from: dropPosition, to: airplaneCenter) < 100 {
                            // Snap: Setze den Offset auf den vordefinierten Zielwert
                            dragOffset = targetOffset
                            attached = true
                        } else {
                            // Andernfalls zurücksetzen
                            dragOffset = .zero
                        }
                    }
            )
    }
}

struct DraggablePartView_Previews: PreviewProvider {
    static var previews: some View {
        // Beispielvorschau – hier muss ein fester Wert für airplaneCenter übergeben werden
        DraggablePartView(
            imageName: "hull",
            targetOffset: .zero,
            initialPosition: CGPoint(x: 60, y: 600),
            attached: .constant(false),
            dragOffset: .constant(.zero),
            airplaneCenter: CGPoint(x: 200, y: 400)
        )
        .previewLayout(.sizeThatFits)
    }
}
