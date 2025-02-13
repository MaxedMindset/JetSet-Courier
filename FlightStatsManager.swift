//
//  FlightStatsManager.swift
//  SkyCraftBuildAndFly
//
//  Verwaltet Echtzeit-Flugstatistiken und publiziert sie als ObservableObject,
//  damit HUD-Elemente in SwiftUI aktualisiert werden können.
//

import SwiftUI
import CoreGraphics
import Combine

class FlightStatsManager: ObservableObject {
    static let shared = FlightStatsManager()
    
    @Published var currentSpeed: CGFloat = 0.0
    @Published var currentAltitude: CGFloat = 0.0
    @Published var flightTime: TimeInterval = 0.0
    @Published var fuelLevel: CGFloat = 100.0
    @Published var damage: CGFloat = 0.0
    
    private var timer: Timer?
    
    private init() { }
    
    func startTracking() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            // Hier werden in einer echten Implementierung Werte aus der FlightScene übernommen.
            // Dummy-Werte zur Demonstration:
            self.currentSpeed = CGFloat.random(in: 250...350)
            self.currentAltitude = CGFloat.random(in: 1400...1600)
            self.flightTime += 0.5
            self.fuelLevel = max(0, self.fuelLevel - 0.2)
            self.damage = CGFloat.random(in: 0...10)
        }
    }
    
    func stopTracking() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetStats() {
        currentSpeed = 0.0
        currentAltitude = 0.0
        flightTime = 0.0
        fuelLevel = 100.0
        damage = 0.0
    }
}
