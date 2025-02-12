//  Diese Klasse verwaltet den Fortschritt im Karrieremodus, wie Level und Story-Punkte.
//  Sie verwendet das Singleton-Muster, sodass der Fortschritt überall im Spiel abrufbar ist.
//

import Foundation

class CareerManager {
    static let shared = CareerManager()
    
    var currentLevel: Int = 1
    var storyPoints: Int = 0
    
    private init() { }
    
    func addStoryPoints(_ points: Int) {
        storyPoints += points
        print("StoryPoints hinzugefügt: \(points), Gesamt: \(storyPoints)")
    }
    
    func levelUp() {
        currentLevel += 1
        print("Level aufgestiegen: \(currentLevel)")
    }
    
    func resetProgress() {
        currentLevel = 1
        storyPoints = 0
    }
}
