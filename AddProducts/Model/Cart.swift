import Foundation

struct Cart {
    var products: [Product]
    
    init(products: [Product] = []) {
        self.products = products
    }
}
