//  Verwaltet Flugstatistiken und aktualisiert sie in Echtzeit, sodass sie im HUD angezeigt werden können.
//
import SwiftUI
import CoreGraphics
import Combine

class FlightStatsManager: ObservableObject {
    static let shared = FlightStatsManager()
    
    @Published var currentSpeed: CGFloat = 0.0
    @Published var currentAltitude: CGFloat = 0.0
    @Published var flightTime: TimeInterval = 0.0
    
    private var timer: Timer?
    
    private init() { }
    
    func startTracking() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            // Hier würden in einer echten App Werte aus der FlightScene übernommen werden.
            // Dummy-Werte zum Testen:
            self.currentSpeed = CGFloat.random(in: 250...350)
            self.currentAltitude = CGFloat.random(in: 1400...1600)
            self.flightTime += 0.5
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
    }
}
