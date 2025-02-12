//  Diese SwiftUI-View zeigt ein Tutorial in mehreren Seiten an, in dem die Grundlagen
//  des Spiels erklärt werden. Der Spieler kann durch die Seiten wischen und am Ende
//  ins Hauptmenü wechseln.
//
import SwiftUI

struct TutorialView: View {
    @State private var currentPage = 0
    
    let pages = [
        "Willkommen zu SkyCraft!\n\nHier baust du dein Flugzeug und startest spannende Missionen.",
        "Im Hangar kannst du dein Flugzeug individuell zusammenbauen.\n\nPasse Gewicht, Auftrieb und Schub an.",
        "Im Flugmodus steuerst du dein Flugzeug mit Wischgesten.\n\nTippe oben, um zu steigen, unten, um zu sinken.",
        "Verbessere dein Flugzeug und verdiene Upgrades durch erfolgreiche Missionen.",
        "Bist du bereit? Drücke 'Los' um ins Hauptmenü zu gelangen!"
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Text(pages[index])
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            if currentPage == pages.count - 1 {
                Button(action: {
                    print("Tutorial abgeschlossen – Wechsel ins Hauptmenü")
                    // Hier könntest du einen Übergang ins Hauptmenü auslösen
                }) {
                    Text("Los")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
                        .padding(.top, 20)
                }
            }
        }
        .padding()
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
