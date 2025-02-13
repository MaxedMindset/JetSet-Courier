//
//  GameDataManager.swift
//  SkyCraftBuildAndFly
//
//  Verwaltet persistente Daten wie Fortschritt, Levels, Achievements und Upgrades.
//  Hier wird UserDefaults als einfaches Speichersystem genutzt.
//

import Foundation

class GameDataManager {
    static let shared = GameDataManager()
    
    private let levelKey = "currentLevel"
    private let storyPointsKey = "storyPoints"
    private let coinsKey = "coins"
    
    var currentLevel: Int {
        get { UserDefaults.standard.integer(forKey: levelKey) }
        set { UserDefaults.standard.set(newValue, forKey: levelKey) }
    }
    
    var storyPoints: Int {
        get { UserDefaults.standard.integer(forKey: storyPointsKey) }
        set { UserDefaults.standard.set(newValue, forKey: storyPointsKey) }
    }
    
    var coins: Int {
        get { UserDefaults.standard.integer(forKey: coinsKey) }
        set { UserDefaults.standard.set(newValue, forKey: coinsKey) }
    }
    
    private init() {
        // Standardwerte setzen, falls noch nicht vorhanden
        if UserDefaults.standard.integer(forKey: levelKey) == 0 {
            currentLevel = 1
        }
        if UserDefaults.standard.integer(forKey: coinsKey) == 0 {
            coins = 500
        }
    }
    
    func saveProgress(level: Int, storyPoints: Int) {
        currentLevel = level
        self.storyPoints = storyPoints
    }
}
