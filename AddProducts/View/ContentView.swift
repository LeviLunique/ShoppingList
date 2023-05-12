import SwiftUI

struct ContentView: View {
    @StateObject private var productViewModel = ProductViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    @State private var showingAddScreen = false
    @State private var showingCartScreen = false
    
    var body: some View {
        NavigationView {
            ProductListView()
                .environmentObject(productViewModel)
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
        }
        .sheet(isPresented: $showingAddScreen) {
            AddProductView(productViewModel: productViewModel)
                .environmentObject(productViewModel)
                .onAppear {
                    print("ContentView - productViewModel: \(productViewModel)")
                }
        }
        .sheet(isPresented: $showingCartScreen) {
            CartView()
                .environmentObject(productViewModel)
                .environmentObject(cartViewModel)
                .onAppear {
                    print("ContentView - productViewModel: \(productViewModel)")
                }
        }
    }
}
