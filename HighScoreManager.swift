//
//  HighScoreManager.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Diese Klasse speichert und lädt den Highscore mithilfe von UserDefaults.
//  Sie erlaubt spätere Erweiterungen, etwa für Ranglisten oder mehrere Score-Kategorien.
//

import Foundation

class HighScoreManager {
    static let shared = HighScoreManager()
    private let highScoreKey = "SkyCraftHighScore"
    
    private init() { }
    
    func getHighScore() -> Int {
        return UserDefaults.standard.integer(forKey: highScoreKey)
    }
    
    func setHighScore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: highScoreKey)
        UserDefaults.standard.synchronize()
    }
}
