class StatsManager {
    static let shared = StatsManager()
    var flightTime: TimeInterval = 0
    var maxSpeed: CGFloat = 0
    var maneuversCount: Int = 0
    // Weitere Statistiken...
    
    private init() { }
    
    func reset() {
        flightTime = 0
        maxSpeed = 0
        maneuversCount = 0
    }
}
