import SwiftUI
import GameplayKit

// Definiere die möglichen Terrain-Typen, deren rawValue den Asset-Namen entspricht
enum TerrainType: String {
    case water = "water"       // z. B. blaues Wasser
    case grass = "grass"       // sanftes Gras
    case forest = "forest"     // dichter Wald
    case mountain = "mountain" // felsige Berge
}

/// Diese View erstellt eine prozedurale Open-World-Map mithilfe von Perlin Noise (über GKNoise) und legt
/// mehrere Layer übereinander, um Tiefe zu erzeugen.
struct ProceduralOpenWorldMapView: View {
    // Konfiguration der Map
    let rows: Int = 30
    let columns: Int = 30
    let tileSize: CGFloat = 32.0
    
    // Der generierte NoiseMap
    let noiseMap: GKNoiseMap
    
    // Initialisierung: Erstelle den Perlin Noise und die zugehörige NoiseMap
    init() {
        // Erstelle eine PerlinNoiseSource mit gewünschten Parametern
        let perlinSource = GKPerlinNoiseSource(frequency: 1.0,
                                               octaveCount: 6,
                                               persistence: 0.5,
                                               lacunarity: 2.0,
                                               seed: Int32.random(in: 0..<1000))
        let noise = GKNoise(perlinSource)
        // Erzeuge die NoiseMap: Die "size" bestimmt, wie stark sich die Werte über die Map ändern
        noiseMap = GKNoiseMap(noise,
                              size: vector_double2(10, 10),
                              origin: vector_double2(0, 0),
                              sampleCount: vector_int2(Int32(columns), Int32(rows)),
                              seamless: true)
    }
    
    var body: some View {
        // Ermögliche sowohl horizontales als auch vertikales Scrollen
        ScrollView([.vertical, .horizontal]) {
            VStack(spacing: 0) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<columns, id: \.self) { col in
                            // Lese den Noise-Wert für das aktuelle Tile
                            let noiseValue = noiseMap.value(at: vector_int2(Int32(col), Int32(row)))
                            let terrain = terrainType(for: noiseValue)
                            
                            // Jeder Tile wird als ZStack aufgebaut, um mehrere Layer (Basis, Vegetation, Objekte) darzustellen
                            ZStack {
                                // Basis-Terrain
                                Image(terrain.rawValue)
                                    .resizable()
                                    .frame(width: tileSize, height: tileSize)
                                
                                // Vegetations-Layer
                                // Bei "forest" wird immer ein Baum (leicht transparent) angezeigt.
                                // Bei "grass" wird gelegentlich (10 % Chance) ein Busch angezeigt.
                                if terrain == .forest {
                                    Image("tree")
                                        .resizable()
                                        .frame(width: tileSize, height: tileSize)
                                        .opacity(0.7)
                                } else if terrain == .grass, Double.random(in: 0...1) < 0.1 {
                                    Image("bush")
                                        .resizable()
                                        .frame(width: tileSize, height: tileSize)
                                        .opacity(0.8)
                                }
                                
                                // Objekt-Layer: In bergigen Regionen (mountain) können gelegentlich Felsen platziert werden.
                                if terrain == .mountain, Double.random(in: 0...1) < 0.05 {
                                    Image("rock")
                                        .resizable()
                                        .frame(width: tileSize, height: tileSize)
                                        .opacity(0.8)
                                }
                            } // ZStack Tile
                        } // ForEach Spalte
                    } // HStack für eine Zeile
                } // ForEach Zeile
            }
        }
        .background(Color.black.opacity(0.1)) // Optionale Hintergrundfarbe
    }
    
    /// Ordnet einen Noise-Wert einem Terrain-Typ zu. Die Schwellenwerte können nach Belieben angepasst werden.
    func terrainType(for value: Float) -> TerrainType {
        // Der Noise-Wert liegt typischerweise im Bereich [-1, 1]
        if value < -0.3 {
            return .water
        } else if value < 0.0 {
            return .grass
        } else if value < 0.4 {
            return .forest
        } else {
            return .mountain
        }
    }
}

struct ProceduralOpenWorldMapView_Previews: PreviewProvider {
    static var previews: some View {
        ProceduralOpenWorldMapView()
            .previewLayout(.sizeThatFits)
    }
}
