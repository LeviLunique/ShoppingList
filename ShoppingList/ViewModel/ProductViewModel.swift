import os.log
import CoreData
import Foundation

class ProductViewModel: ObservableObject {
    @Published var name = ""
    @Published var valueString = ""
    @Published var quantityString = "1"
    @Published var productList: [Product] = []
    @Published var error: Error?
    @Published var productExistsError: Bool = false
    @Published var inputError: Bool = false   // Adicionado
    private let persistenceController: PersistenceController
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ProductViewModel")

    init(persistenceController: PersistenceController = .shared) {
        os_log(.info, log: log, "ProductViewModel initialized")
        self.persistenceController = persistenceController
        fetchProducts()
    }
    
    // Métodos de AddProductViewModel
    
    func addProduct(completion: @escaping () -> Void) {
        guard let value = convertToFloat(valueString), let quantity = Int(quantityString) else {
            os_log(.error, log: log, "Erro na conversão de valueString ou quantityString.")
            inputError = true
            return
        }
        
        persistenceController.container.performBackgroundTask { [self] context in
            do {
                let fetchRequest: NSFetchRequest<CoreDataProduct> = CoreDataProduct.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name == %@", name)
                
                let existingProducts = try context.fetch(fetchRequest)
                if let _ = existingProducts.first {
                    os_log(.info, log: log, "Produto com o mesmo nome já existe.")
                    DispatchQueue.main.async {
                        productExistsError = true
                    }
                    return
                }
                
                let product = CoreDataProduct(context: context)
                product.name = self.name
                product.value = value
                product.quantity = Int32(quantity)
                product.totalValue = value * Float(quantity)
                
                // Atribuir um valor a productId
                product.productId = UUID()
                
                try context.save()
                DispatchQueue.main.async {
                    fetchProducts()
                    os_log(.info, log: log, "Produto adicionado com sucesso.")
                    os_log(.info, log: log, "Total de produtos recuperados: \(self.productList.count)")
                    self.resetFields()
                    completion()  // Chame completion() aqui.
                }
            } catch {
                // Tratar o erro ao salvar o contexto do CoreData ou ao buscar produtos existentes
                DispatchQueue.main.async {
                    self.error = error
                }
            }
        }
    }

    
    func productExists(withName name: String) -> Bool {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<CoreDataProduct> = CoreDataProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let existingProducts = try context.fetch(fetchRequest)
            if let _ = existingProducts.first {
                return true
            }
        } catch {
            os_log(.info, log: log, "Erro ao buscar produtos existentes: \(error)")
        }
        
        return false
    }
    
    func validateInput() -> Bool {
        // Perform validation on input fields
        guard !name.isEmpty, convertToFloat(valueString) != nil, Int(quantityString) != nil else {
            return false
        }
        // Return true if the input is valid, otherwise false
        return true
    }
    
    func resetFields() {
        name = ""
        valueString = ""
        quantityString = "1"
        inputError = false  // Reset inputError
        productExistsError = false // Reset productExistsError
    }

    // Métodos de ProductListViewModel

    func fetchProducts() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<CoreDataProduct> = CoreDataProduct.fetchRequest()

        do {
            let fetchedProducts = try context.fetch(fetchRequest)
            productList = fetchedProducts.map { coreDataProduct in
                Product(id: coreDataProduct.productId ?? UUID(),
                        name: coreDataProduct.name ?? "",
                        value: coreDataProduct.value,
                        quantity: coreDataProduct.quantity,
                        totalValue: coreDataProduct.totalValue)
            }
            os_log(.info, log: log, "Produtos recuperados: \(self.productList.count)")
        } catch {
            os_log(.info, log: log, "Erro ao recuperar os produtos do CoreData: \(error)")
        }
    }
    
    func removeProduct(at index: Int) {
        let context = PersistenceController.shared.container.viewContext
        let product = productList[index]
        let fetchRequest: NSFetchRequest<CoreDataProduct> = CoreDataProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CoreDataProduct.productId), product.id as CVarArg)

        do {
            let fetchedProducts = try context.fetch(fetchRequest)
            os_log(.info, log: log, "Total de produtos encontrados: \(fetchedProducts.count)")
            if let coreDataProduct = fetchedProducts.first {
                context.delete(coreDataProduct)
                
                try context.save()
                os_log(.info, log: log, "Produto removido com sucesso.")

                // Chame fetchProducts() para atualizar a lista de produtos após a exclusão bem-sucedida
                fetchProducts()
            }
        } catch {
            os_log(.info, log: log, "Erro ao buscar o produto para remover: \(error)")
        }
    }
    
    func updateQuantity(for product: Product, newQuantity: Int32) {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<CoreDataProduct> = CoreDataProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CoreDataProduct.productId), product.id as CVarArg)

        do {
            let fetchedProducts = try context.fetch(fetchRequest)
            if let coreDataProduct = fetchedProducts.first {
                coreDataProduct.quantity = newQuantity
                
                updateTotalValue(for: coreDataProduct)

                try context.save()
                fetchProducts()
            }
        } catch {
            // Tratar o erro ao recuperar e atualizar o produto do CoreData
        }
    }
    
    private func updateTotalValue(for coreDataProduct: CoreDataProduct) {
        coreDataProduct.totalValue = coreDataProduct.value * Float(coreDataProduct.quantity)
    }
    
    func totalSum() -> Float {
        productList.reduce(0) { $0 + $1.totalValue }
    }

    func updateProduct(_ product: Product, name: String, value: Float, quantity: Int32) {
        os_log(.info, log: log, "Iniciando atualização do produto com ID: %{public}@", product.id.uuidString)
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<CoreDataProduct> = CoreDataProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CoreDataProduct.productId), product.id as CVarArg)

        do {
            let fetchedProducts = try context.fetch(fetchRequest)
            if let coreDataProduct = fetchedProducts.first {
                // Verificar se existe outro produto com o mesmo nome, mas com ID diferente
                let nameFetchRequest: NSFetchRequest<CoreDataProduct> = CoreDataProduct.fetchRequest()
                nameFetchRequest.predicate = NSPredicate(format: "name == %@ AND productId != %@", name, coreDataProduct.productId as CVarArg)
                let existingProducts = try context.fetch(nameFetchRequest)

                if !existingProducts.isEmpty {
                    os_log(.info, log: log, "Encontrado produto duplicado com nome: %{public}@", name)
                    DispatchQueue.main.async {
                        self.productExistsError = true
                    }
                    return
                }

                os_log(.info, log: log, "Atualizando produto com ID: %{public}@", coreDataProduct.productId.uuidString)
                coreDataProduct.name = name
                coreDataProduct.value = value
                coreDataProduct.quantity = quantity
                updateTotalValue(for: coreDataProduct)

                try context.save()
                fetchProducts()
            } else {
                os_log(.info, log: log, "Produto com ID: %{public}@ não encontrado para atualização", product.id.uuidString)
            }
        } catch {
            os_log(.error, log: log, "Erro ao atualizar o produto: %{public}@", error.localizedDescription)
        }
    }

    
    func convertToFloat(_ string: String) -> Float? {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        if let number = formatter.number(from: string) {
            return Float(truncating: number)
        }
        formatter.decimalSeparator = "."
        if let number = formatter.number(from: string) {
            return Float(truncating: number)
        }
        return nil
    }

    func getProduct(withName name: String) -> CoreDataProduct? {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<CoreDataProduct> = CoreDataProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            let existingProducts = try context.fetch(fetchRequest)
            return existingProducts.first
        } catch {
            os_log(.info, log: log, "Erro ao buscar produto existente: \(error)")
        }

        return nil
    }

}
