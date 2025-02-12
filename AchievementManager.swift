struct Achievement {
    let id: String
    let title: String
    let description: String
    var isUnlocked: Bool = false
}

class AchievementManager {
    static let shared = AchievementManager()
    var achievements: [Achievement] = [
        Achievement(id: "perfectLanding", title: "Perfekte Landung", description: "Führe 10 perfekte Landungen durch."),
        Achievement(id: "speedDemon", title: "Geschwindigkeitsfreak", description: "Erreiche eine Höchstgeschwindigkeit von 500 km/h."),
        Achievement(id: "noDamage", title: "Unbesiegt", description: "Beende 5 Missionen ohne Schaden.")
    ]
    
    private init() { }
    
    func unlockAchievement(id: String) {
        if let index = achievements.firstIndex(where: { $0.id == id }) {
            achievements[index].isUnlocked = true
            // Hier könntest du eine Benachrichtigung oder Animation anzeigen.
        }
    }
}
