class EconomyManager {
    static let shared = EconomyManager()
    var coins: Int = 500  // Startwährung
    private init() { }
    
    func addCoins(_ amount: Int) {
        coins += amount
    }
    
    func spendCoins(_ amount: Int) -> Bool {
        if coins >= amount {
            coins -= amount
            return true
        }
        return false
    }
}
