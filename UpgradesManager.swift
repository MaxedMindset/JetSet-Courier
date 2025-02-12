//
//  UpgradesManager.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Diese Klasse verwaltet die In-Game-Währung und Upgrades, die der Spieler erwerben kann.
//  Upgrades beeinflussen Parameter wie Gewicht, Auftrieb und Schubkraft des Flugzeugs.
//
import Foundation
import CoreGraphics

struct Upgrade {
    let name: String
    let description: String
    let cost: Int
    let weightModifier: CGFloat  // z. B. 0.9 = 10% Gewichtseinsparung
    let liftModifier: CGFloat    // z. B. 1.15 = 15% erhöhter Auftrieb
    let thrustModifier: CGFloat  // z. B. 1.2 = 20% mehr Schub
}

class UpgradesManager {
    static let shared = UpgradesManager()
    var inGameCurrency: Int = 500  // Startwährung (kann durch Missionen erhöht werden)
    var availableUpgrades: [Upgrade] = []
    
    private init() {
        // Beispiel-Upgrades
        availableUpgrades.append(Upgrade(name: "Leichtbau Material",
                                         description: "Reduziert Gewicht um 10%",
                                         cost: 100,
                                         weightModifier: 0.9,
                                         liftModifier: 1.0,
                                         thrustModifier: 1.0))
        availableUpgrades.append(Upgrade(name: "Verbessertes Aerodynamik-Design",
                                         description: "Erhöht Auftrieb um 15%",
                                         cost: 150,
                                         weightModifier: 1.0,
                                         liftModifier: 1.15,
                                         thrustModifier: 1.0))
        availableUpgrades.append(Upgrade(name: "Turbo-Triebwerk",
                                         description: "Erhöht Schub um 20%",
                                         cost: 200,
                                         weightModifier: 1.0,
                                         liftModifier: 1.0,
                                         thrustModifier: 1.2))
    }
    
    func purchaseUpgrade(_ upgrade: Upgrade) -> Bool {
        if inGameCurrency >= upgrade.cost {
            inGameCurrency -= upgrade.cost
            return true
        }
        return false
    }
}
