import SwiftUI

struct CartView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var productViewModel: ProductViewModel
    
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
            productViewModel.products.removeAll()
        }) {
            Text("Limpar")
        }
    }
    
    var body: some View {
        NavigationView {
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
                                    UIApplication.shared.windows.first?.endEditing(true)
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
            .navigationTitle("Carrinho")
            .navigationBarItems(leading: backButton, trailing: clearButton)
        }
    }
}
