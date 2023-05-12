import Foundation
import SwiftUI

class AddProductViewModel: ObservableObject {
    @Published var name = ""
    @Published var valueString = ""
    @Published var quantityString = "1"
    
    public var productViewModel: ProductViewModel
    
    init(productViewModel: ProductViewModel) {
        self.productViewModel = productViewModel
    }
    
    func addProduct() {
        if let value = Float(valueString), let quantity = Int(quantityString) {
            var product = Product(name: name, value: value, quantity: quantity)
            product.totalValue = value * Float(quantity)
            productViewModel.addProduct(product)
            resetFields()
        }
    }
    
    func incrementQuantity() {
        if let quantity = Int(quantityString) {
            quantityString = String(quantity + 1)
        }
    }
    
    func decrementQuantity() {
        if let quantity = Int(quantityString), quantity > 1 {
            quantityString = String(quantity - 1)
        }
    }
    
    func validateInput() -> Bool {
        // Perform validation on input fields
        // Return true if the input is valid, otherwise false
        // You can add your validation logic here
        return true
    }
    
    private func resetFields() {
        name = ""
        valueString = ""
        quantityString = "1"
    }
}
