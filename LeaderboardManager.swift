//
//  LeaderboardManager.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Diese Klasse simuliert das Reporten von Scores an ein Leaderboard.
//  In einer echten Implementierung könntest du hier GameKit, Firebase oder eine andere Backend-Lösung einbinden.
//
import Foundation

class LeaderboardManager {
    static let shared = LeaderboardManager()
    
    private init() { }
    
    func reportScore(_ score: Int) {
        // Hier würdest du den Score an deinen Backend-Service oder Game Center senden.
        // Für dieses Beispiel simulieren wir das mit einem Debug-Print.
        print("Score reported to leaderboard: \(score)")
    }
}
