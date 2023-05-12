import Foundation

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    func addProduct(_ product: Product) {
           products.append(product)
       }
    
    func increaseQuantity(for product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            var updatedProduct = product
            updatedProduct.quantity += 1
            updateTotalValue(for: &updatedProduct)
            products[index] = updatedProduct
        }
    }

    func decreaseQuantity(for product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            if products[index].quantity > 1 {
                var updatedProduct = product
                updatedProduct.quantity -= 1
                updateTotalValue(for: &updatedProduct)
                products[index] = updatedProduct
            }
        }
    }

    private func updateTotalValue(for product: inout Product) {
        product.totalValue = product.value * Float(product.quantity)
    }

}

