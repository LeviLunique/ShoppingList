import Foundation

struct Product: Identifiable {
    let id = UUID()
    var name: String
    var value: Float
    var quantity: Int
    var totalValue: Float?
    
    init(name: String, value: Float, quantity: Int = 1, totalValue: Float? = nil) {
        self.name = name
        self.value = value
        self.quantity = quantity
        self.totalValue = totalValue
    }
}
