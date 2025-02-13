//
//  ProfileView.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//
//  Diese View zeigt eine Liste von Profilen an und ermöglicht es dem Spieler,
//  neue Profile zu erstellen oder bestehende zu löschen.
//
import SwiftUI

struct Profile: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
}

class ProfileManager: ObservableObject {
    @Published var profiles: [Profile] = []
    
    init() {
        loadProfiles()
    }
    
    func loadProfiles() {
        if let data = UserDefaults.standard.data(forKey: "profiles"),
           let savedProfiles = try? JSONDecoder().decode([Profile].self, from: data) {
            profiles = savedProfiles
        }
    }
    
    func saveProfiles() {
        if let data = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(data, forKey: "profiles")
        }
    }
    
    func addProfile(name: String) {
        let newProfile = Profile(id: UUID(), name: name)
        profiles.append(newProfile)
        saveProfiles()
    }
    
    func deleteProfile(at offsets: IndexSet) {
        profiles.remove(atOffsets: offsets)
        saveProfiles()
    }
}

struct ProfileView: View {
    @ObservedObject var profileManager = ProfileManager()
    @State private var newProfileName: String = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(profileManager.profiles) { profile in
                    Text(profile.name)
                }
                .onDelete(perform: profileManager.deleteProfile)
            }
            HStack {
                TextField("Neues Profil", text: $newProfileName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Hinzufügen") {
                    withAnimation {
                        profileManager.addProfile(name: newProfileName)
                        newProfileName = ""
                    }
                }
                .disabled(newProfileName.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Profile verwalten")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
