import SwiftUI

struct UpgradesScene: View {
    // Beispiel-Daten für Upgrades
    @State private var availableUpgrades: [UpgradeItem] = [
        UpgradeItem(name: "Motor Upgrade", description: "Erhöht die Geschwindigkeit um 20%", cost: "$500"),
        UpgradeItem(name: "Fahrwerk Upgrade", description: "Verbessert die Stabilität bei Landungen", cost: "$300"),
        UpgradeItem(name: "Flügel Upgrade", description: "Verbessert die Manövrierfähigkeit", cost: "$400")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrund: ein sanfter Farbverlauf
                LinearGradient(
                    gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Upgrades")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    List(availableUpgrades) { upgrade in
                        UpgradeRow(upgrade: upgrade)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationBarTitle("", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct UpgradesScene_Previews: PreviewProvider {
    static var previews: some View {
        UpgradesScene()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}

// Datenmodell für ein Upgrade
struct UpgradeItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let cost: String
}

// Zeile für jedes Upgrade in der Liste
struct UpgradeRow: View {
    let upgrade: UpgradeItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(upgrade.name)
                    .font(.headline)
                Text(upgrade.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(upgrade.cost)
                .font(.headline)
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
}
