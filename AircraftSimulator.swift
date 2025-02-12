//
//  AircraftSimulator.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT – Erweiterte Version
//
//  Diese Klasse berechnet einen "Flugbereitschaftsindex" basierend auf der
//  AircraftConfiguration. Sie gibt einen numerischen Wert zurück und liefert eine
//  textuelle Bewertung, die angibt, ob das Flugzeug flugtauglich ist oder nicht.
//

import Foundation
import CoreGraphics

class AircraftSimulator {
    /// Berechnet den Flugbereitschaftsindex.
    /// Die Formel ist ein Beispiel und kann je nach gewünschtem Gameplay angepasst werden.
    /// Hier wird angenommen, dass eine Kombination aus Auftrieb, Schub und Stabilität dem Gewicht gegenübergestellt wird.
    static func calculateFlightReadiness(for configuration: AircraftConfiguration) -> Float {
        // Beispielhafte Faktoren:
        // - 50% der Bewertung kommen aus dem Auftrieb,
        // - 35% aus dem Schub (multipliziert mit einem Faktor, hier 0.7),
        // - 15% aus der Stabilität.
        // Das Gewicht wird dabei als negativer Einfluss einbezogen.
        let liftFactor: Float = 0.5
        let thrustFactor: Float = 0.7
        let stabilityFactor: Float = Float(configuration.stability)
        
        // Berechnung: (Auftrieb * liftFactor + Schub * thrustFactor - Gewicht) * Stabilität
        let readiness = (Float(configuration.lift) * liftFactor +
                         Float(configuration.thrust) * thrustFactor -
                         Float(configuration.weight)) * stabilityFactor
        return readiness
    }
    
    /// Liefert eine textuelle Bewertung basierend auf dem Flugbereitschaftsindex.
    static func readinessRating(for configuration: AircraftConfiguration) -> String {
        let readiness = calculateFlightReadiness(for: configuration)
        if readiness < 20 {
            return "Schlecht – Das Flugzeug hebt kaum ab."
        } else if readiness < 50 {
            return "Verbesserungswürdig – Flugzeug instabil."
        } else {
            return "Flugbereit – Optimales Design!"
        }
    }
}
