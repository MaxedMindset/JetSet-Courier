//
//  ShopItem.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Dieses Modell repräsentiert einen Shop-Artikel im In-Game-Shop, der Upgrades für das Flugzeug bietet.
//

import CoreGraphics

struct ShopItem {
    let name: String
    let description: String
    let cost: Int
    let weightModifier: CGFloat  // z. B. 0.85 reduziert das Gewicht um 15%
    let liftModifier: CGFloat    // z. B. 1.20 erhöht den Auftrieb um 20%
    let thrustModifier: CGFloat  // z. B. 1.25 erhöht den Schub um 25%
}
