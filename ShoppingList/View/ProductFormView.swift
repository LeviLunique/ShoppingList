import SwiftUI

enum ProductError: LocalizedError, Identifiable {
    case inputValidation
    case productExists
    
    var id: Int {
        switch self {
        case .inputValidation:
            return 1
        case .productExists:
            return 2
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .inputValidation:
            return "Os campos de Nome, Valor ou Quantidade estão vazios ou não são válidos."
        case .productExists:
            return "Um produto com este nome já existe."
        }
    }
}


struct ProductFormView: View {
    var title: String
    @Binding var product: Product?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var productViewModel: ProductViewModel

    @State private var currentError: ProductError?

    var isNewProduct: Bool {
        product == nil
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Nome do Produto", text: $productViewModel.name)
                TextField("Valor", text: $productViewModel.valueString)
                    .keyboardType(.numbersAndPunctuation)
                HStack {
                    Text("Quantidade")
                    Spacer()
                    Stepper(value: Binding(
                        get: { Int(productViewModel.quantityString) ?? 1 },
                        set: { productViewModel.quantityString = String($0) }
                    ), in: 1...100) {
                        Text("\(productViewModel.quantityString)")
                    }
                }
            }
            .onAppear {
                if isNewProduct {
                    productViewModel.resetFields()
                }
            }
            .navigationTitle(title)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .alert(item: $currentError) { error in
                Alert(title: Text("Erro"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
            }
        }
        .onReceive(productViewModel.$error) { newError in
            if let _ = newError {
                currentError = .inputValidation
            }
        }
    }

    private var cancelButton: some View {
        Button("Cancelar") {
            presentationMode.wrappedValue.dismiss()
        }
    }

    private var saveButton: some View {
        Button("Salvar") {
            if productViewModel.validateInput() {
                guard let value = productViewModel.convertToFloat(productViewModel.valueString), let quantity = Int32(productViewModel.quantityString) else {
                    return
                }
                if productViewModel.productExists(withName: productViewModel.name) {
                    currentError = .productExists
                    return
                }
                if let product = product {
                    productViewModel.updateProduct(product, name: productViewModel.name, value: value, quantity: quantity)
                    presentationMode.wrappedValue.dismiss()
                } else {
                    productViewModel.addProduct {
                        product = nil
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } else {
                currentError = .inputValidation
            }
        }
    }
}
