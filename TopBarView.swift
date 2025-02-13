import SwiftUI

struct TopBarView: View {
    let level: String
    let money: String
    let rank: String

    var body: some View {
        HStack {
            Text(level)
                .font(.headline)
                .padding(.leading, 20)
            Spacer()
            Text(money)
                .font(.headline)
            Spacer()
            Text(rank)
                .font(.headline)
                .padding(.trailing, 20)
        }
        .frame(height: 50)
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .padding()
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView(level: "Level 1", money: "$1000", rank: "Platz 5")
            .previewLayout(.sizeThatFits)
    }
}
