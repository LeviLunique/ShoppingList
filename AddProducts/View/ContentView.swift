import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject private var productViewModel: ProductViewModel
    @StateObject private var cartViewModel: CartViewModel = CartViewModel(context: PersistenceController.shared.container.viewContext)
    
    @State private var showingAddScreen = false
    @State private var showingCartScreen = false
    @State private var productToEdit: Product?
    
    var body: some View {
        NavigationView {
            ProductListView()
                .navigationBarItems(trailing: Button(action: {
                    showingCartScreen = true
                }) {
                    Text("Carrinho")
                })
                .overlay(
                    Button(action: {
                        showingAddScreen = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .offset(x: -16, y: -16),
                    alignment: .bottomTrailing
                )
                .sheet(isPresented: $showingAddScreen) {
                    ProductFormView(title: productToEdit == nil ? "Adicionar Produto" : "Editar Produto",
                                    product: $productToEdit)
                        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                }
                .sheet(isPresented: $showingCartScreen) {
                    CartView(cartViewModel: cartViewModel)
                }
        }
        .environmentObject(productViewModel)
    }
}
