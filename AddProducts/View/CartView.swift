// CartView
import SwiftUI

struct CartView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var managedObjectContext
    @ObservedObject var cartViewModel: CartViewModel
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
        }
    }
    
    private var clearButton: some View {
        Button(action: {
            cartViewModel.clearCart()
        }) {
            Text("Limpar")
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(cartViewModel.cartProducts.enumerated()), id: \.element) { index, product in
                    if let product = product as? CoreDataProduct {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading) {
                                Text(product.name ?? "Nome indisponível")
                                    .font(.headline)
                                
                                Text("R$\(product.totalValue, specifier: "%.2f")")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            HStack(spacing: 0) {
                                Text("\(product.quantity)")
                                    .padding(.trailing, 8)
                                    .onTapGesture {
                                        UIApplication.shared.windows.first?.endEditing(true)
                                    }
                                Stepper("", value: Binding(
                                    get: {
                                        Int(cartViewModel.cartProducts[index].quantity)
                                    },
                                    set: { value in
                                        cartViewModel.updateQuantity(at: index, newQuantity: value)
                                    }
                                ), in: 1...Int.max)
                                .labelsHidden()
                            }
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    let product = cartViewModel.cartProducts[indexSet.first!]
                    cartViewModel.removeProductFromCart(product)
                })
            }
            .navigationTitle("Carrinho")
            .navigationBarItems(leading: backButton, trailing: clearButton)
        }
    }
}
