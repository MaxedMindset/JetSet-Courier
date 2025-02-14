import SwiftUI

struct ReplayScene: View {
    @State private var selectedReplay: String? = nil
    let replays = ["Replay 1", "Replay 2", "Replay 3"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrundbild
                Image("replayBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Replays")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    List(replays, id: \.self) { replay in
                        Button(action: {
                            selectedReplay = replay
                        }) {
                            Text(replay)
                                .foregroundColor(.blue)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Replays", displayMode: .inline)
        }
    }
}

struct ReplayScene_Previews: PreviewProvider {
    static var previews: some View {
        ReplayScene()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}
