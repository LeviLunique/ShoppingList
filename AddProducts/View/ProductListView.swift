import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    
    var body: some View {
        List {
            ForEach(productViewModel.products) { product in
                HStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text(product.name)
                            .font(.headline)
                        Text("R$\(product.totalValue ?? 0, specifier: "%.2f")")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    HStack(spacing: 0) {
                        Text("\(product.quantity)")
                            .padding(.trailing, 8)
                            .onTapGesture {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        Stepper("", onIncrement: {
                            productViewModel.increaseQuantity(for: product)
                        }, onDecrement: {
                            productViewModel.decreaseQuantity(for: product)
                        })
                        .labelsHidden()
                    }
                }
            }
            .onDelete(perform: { indexSet in
                productViewModel.products.remove(atOffsets: indexSet)
            })
        }
        .navigationTitle("Lista de Produtos")
    }
}
