class AircraftConfigurationManager {
    static let shared = AircraftConfigurationManager()
    var configuration: AircraftConfiguration = AircraftConfiguration()
    private init() { }
}
