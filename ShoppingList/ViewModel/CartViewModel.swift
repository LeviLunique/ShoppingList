import Foundation
import CoreData

class CartViewModel: ObservableObject {
    @Published private(set) var cartProducts: [CoreDataProduct] = []
    
    private let cart: CoreDataCart
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        if let fetchedCart = try? context.fetch(CoreDataCart.fetchRequest()).first as? CoreDataCart {
            self.cart = fetchedCart
        } else {
            self.cart = CoreDataCart(context: context)
            self.cart.cartId = UUID()
            try? context.save()
        }
        self.cartProducts = cart.products?.allObjects as? [CoreDataProduct] ?? []
    }
    
    func removeProductFromCart(_ product: CoreDataProduct) {
        if let index = cartProducts.firstIndex(where: { $0.productId == product.productId }) {
            cartProducts.remove(at: index)
            cart.removeFromProducts(product)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    func clearCart() {
        if let cartProductsSet = cart.products as? Set<CoreDataProduct> {
            for product in cartProductsSet {
                cart.removeFromProducts(product)
            }
        }
        cartProducts.removeAll()
        saveContext()
    }
    
    func updateQuantity(at index: Int, newQuantity: Int) {
        if index < cartProducts.count {
            cartProducts[index].quantity = Int32(newQuantity)
            updateTotalValue(for: &cartProducts[index])
            saveContext()
        }
    }
    
    private func updateTotalValue(for product: inout CoreDataProduct) {
        product.totalValue = product.value * Float(product.quantity)
    }
}
