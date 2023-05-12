import SwiftUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var productViewModel: ProductViewModel
    
    @StateObject private var addProductViewModel: AddProductViewModel
    
    init(productViewModel: ProductViewModel) {
        self._addProductViewModel = StateObject(wrappedValue: AddProductViewModel(productViewModel: productViewModel))
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Nome do Produto", text: $addProductViewModel.name)
                TextField("Valor", text: $addProductViewModel.valueString)
                    .keyboardType(.decimalPad)
                HStack {
                    Text("Quantidade")
                    Spacer()
                    Stepper(onIncrement: {
                        self.addProductViewModel.incrementQuantity()
                    }, onDecrement: {
                        self.addProductViewModel.decrementQuantity()
                    }) {
                        Text("\(self.addProductViewModel.quantityString)")
                    }
                }
            }
            .navigationTitle("Adicionar Produto")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
        .environmentObject(addProductViewModel)
        .onAppear {
            print("AddProductView - productViewModel: \(productViewModel)")
            addProductViewModel.productViewModel = productViewModel
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            cancelAddProduct()
        }) {
            Text("Cancelar")
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            if addProductViewModel.validateInput() {
                addProductViewModel.addProduct()
                presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Salvar")
        }
    }
    
    private func cancelAddProduct() {
        presentationMode.wrappedValue.dismiss()
    }
}
