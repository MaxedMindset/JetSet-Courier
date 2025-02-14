import SwiftUI

// Definiere die möglichen Terrain-Typen
enum TileType: String, CaseIterable {
    case grass      // Innenbereich
    case mountain   // Berge (für Grenzen und gelegentlich im Inneren)
    case forest     // Wälder (für Grenzen und gelegentlich im Inneren)
}

// Funktion zur Generierung der Map als 2D-Array
func generateMap(rows: Int, columns: Int) -> [[TileType]] {
    var map = Array(repeating: Array(repeating: TileType.grass, count: columns), count: rows)
    
    for row in 0..<rows {
        for col in 0..<columns {
            // Setze die Grenzen der Map
            if row == 0 || row == rows - 1 || col == 0 || col == columns - 1 {
                // Zufällig entweder Berg oder Wald an den Rändern
                map[row][col] = Bool.random() ? .mountain : .forest
            } else {
                // Im Inneren: überwiegend Gras, gelegentlich Wald oder Berg
                let r = Double.random(in: 0...1)
                if r < 0.1 {
                    map[row][col] = .forest
                } else if r < 0.2 {
                    map[row][col] = .mountain
                } else {
                    map[row][col] = .grass
                }
            }
        }
    }
    return map
}

// SwiftUI-View zur Darstellung der Map
struct OpenWorldMapView: View {
    let map: [[TileType]]
    let tileSize: CGFloat = 50.0
    
    // Erstelle eine Grid-Definition, basierend auf der Anzahl der Spalten
    var columns: [GridItem] {
        Array(repeating: GridItem(.fixed(tileSize), spacing: 0), count: map.first?.count ?? 0)
    }
    
    var body: some View {
        // Erlaube horizontales und vertikales Scrollen
        ScrollView([.vertical, .horizontal]) {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<map.count, id: \.self) { row in
                    ForEach(0..<map[row].count, id: \.self) { col in
                        Image(map[row][col].rawValue) // Die Asset-Namen entsprechen den rawValues ("grass", "mountain", "forest")
                            .resizable()
                            .frame(width: tileSize, height: tileSize)
                    }
                }
            }
        }
        .background(Color.black.opacity(0.1)) // Optionale Hintergrundfarbe für besseren Kontrast
    }
}

struct OpenWorldMapView_Previews: PreviewProvider {
    static var previews: some View {
        // Beispiel: Erstelle eine 20x20-Map
        let generatedMap = generateMap(rows: 20, columns: 20)
        OpenWorldMapView(map: generatedMap)
            .previewLayout(.sizeThatFits)
    }
}
