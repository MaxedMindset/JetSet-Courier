//
//  CareerManager.swift
//  SkyCraftBuildAndFly
//
//  Verwaltet den Fortschritt im Karrieremodus (Level und StoryPoints) und speichert diesen persistent.
//

import Foundation

class CareerManager {
    static let shared = CareerManager()
    
    private let levelKey = "currentLevel"
    private let pointsKey = "storyPoints"
    
    var currentLevel: Int {
        didSet {
            UserDefaults.standard.set(currentLevel, forKey: levelKey)
        }
    }
    var storyPoints: Int {
        didSet {
            UserDefaults.standard.set(storyPoints, forKey: pointsKey)
        }
    }
    
    private init() {
        // Lade die gespeicherten Werte oder setze Standardwerte
        currentLevel = UserDefaults.standard.integer(forKey: levelKey)
        if currentLevel == 0 { currentLevel = 1 }
        storyPoints = UserDefaults.standard.integer(forKey: pointsKey)
    }
    
    func addStoryPoints(_ points: Int) {
        storyPoints += points
        print("Added \(points) story points. Total now: \(storyPoints)")
    }
    
    func levelUp() {
        currentLevel += 1
        print("Level up! Now at level \(currentLevel)")
    }
    
    func resetProgress() {
        currentLevel = 1
        storyPoints = 0
    }
}
