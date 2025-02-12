//
//  AppDelegate.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Initialisiert das Hauptfenster und startet den GameViewController
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // Application Lifecycle
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Erstelle das Hauptfenster und setze den GameViewController als Root
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = GameViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}
