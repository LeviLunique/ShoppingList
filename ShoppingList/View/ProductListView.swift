import SwiftUI
import CoreData

struct ProductListView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @State private var showingAlert = false
    @State private var showingEditSheet = false
    @State private var selectedProduct: Product?

    var body: some View {
        List {
            ForEach(productViewModel.productList, id: \.id) { product in
                productCell(product: product)
            }
            .onDelete(perform: removeProducts)
            if !productViewModel.productList.isEmpty {
                Text("Valor total: R$\(productViewModel.totalSum(), specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.primary)  // Alteração aqui
                    .listRowBackground(Color.gray.opacity(0.1))
            }
        }
        .navigationTitle("Lista de Produtos")
        .alert(isPresented: $productViewModel.productExistsError) {
            Alert(title: Text("Produto já existe"),
                  message: Text("Um produto com esse nome já existe, por favor escolha um nome diferente."),
                  dismissButton: .default(Text("OK")) {
                    productViewModel.productExistsError = false
                  })
        }
        .sheet(isPresented: $showingEditSheet) {
            ProductFormView(title: "Editar Produto", product: $selectedProduct)
                .environmentObject(productViewModel)
        }
    }

    private func productCell(product: Product) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.primary)  // Alteração aqui
                    .onTapGesture(count: 2) {
                        self.showingEditSheet = true
                        self.selectedProduct = product
                        productViewModel.name = product.name
                        productViewModel.valueString = String(product.value)
                        productViewModel.quantityString = String(product.quantity)
                    }
                Text("R$\(product.totalValue, specifier: "%.2f")")
                    .foregroundColor(.secondary)
            }
            Spacer()
            HStack {
                Text("\(product.quantity)")
                Stepper(value: Binding(
                    get: { Int(product.quantity) },
                    set: { newValue in
                        productViewModel.updateQuantity(for: product, newQuantity: Int32(newValue))
                    }),
                    in: 0...Int(Int32.max),
                    label: { EmptyView() }
                )
                .frame(width: 100)
            }
        }
        .padding(.horizontal, 6)
    }

    private func removeProducts(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                productViewModel.removeProduct(at: index)
            }
        }
    }
}
