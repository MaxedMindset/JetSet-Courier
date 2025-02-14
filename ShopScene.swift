import SwiftUI

struct ShopScene: View {
    let items = [
        ShopItem(name: "Upgrade 1", price: "$100"),
        ShopItem(name: "Upgrade 2", price: "$200"),
        ShopItem(name: "Cosmetic Pack", price: "$150")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrundbild
                Image("shopBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Shop")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    List(items) { item in
                        ShopItemRow(item: item)
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Shop", displayMode: .inline)
        }
    }
}

struct ShopScene_Previews: PreviewProvider {
    static var previews: some View {
        ShopScene()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}

struct ShopItem: Identifiable {
    let id = UUID()
    let name: String
    let price: String
}

struct ShopItemRow: View {
    let item: ShopItem
    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Text(item.price)
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
}
