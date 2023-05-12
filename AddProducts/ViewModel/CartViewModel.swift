import Foundation

class CartViewModel: ObservableObject {
    @Published var cart: Cart
    
    init(cart: Cart = Cart()) {
        self.cart = cart
    }
    
    func increaseQuantity(for product: Product) {
        if let index = cart.products.firstIndex(where: { $0.id == product.id }) {
            cart.products[index].quantity += 1
        }
    }
    
    func decreaseQuantity(for product: Product) {
        if let index = cart.products.firstIndex(where: { $0.id == product.id }) {
            if cart.products[index].quantity > 1 {
                cart.products[index].quantity -= 1
            } else {
                cart.products.remove(at: index)
            }
        }
    }
    
    func removeProduct(at index: Int) {
        cart.products.remove(at: index)
    }
}
