import CoreGraphics

struct AircraftConfiguration {
    var weight: CGFloat = 100.0   // Höheres Gewicht macht das Flugzeug schwerer abzuheben.
    var lift: CGFloat = 100.0     // Größere Flügel (höherer Lift) erleichtern den Auftrieb.
    var thrust: CGFloat = 100.0   // Mehr Schub ermöglicht schnelleres Abheben.
    var stability: CGFloat = 1.0  // Beeinflusst das Flugverhalten (Wendigkeit/Stabilität).
}
