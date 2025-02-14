import SwiftUI

struct StoryScene: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Story Mode")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("Chapter 1: The Beginning")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("In a world where aerial couriers deliver critical packages, you are tasked with the ultimate mission. Embark on a journey filled with challenges, rivalries, and the thrill of flight!")
                        .font(.body)
                    
                    // Weitere Story-Inhalte können hier ergänzt werden.
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Story", displayMode: .inline)
        }
    }
}

struct StoryScene_Previews: PreviewProvider {
    static var previews: some View {
        StoryScene()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}

