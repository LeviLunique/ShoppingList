import SwiftUI

@main
struct AddProductsApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var productViewModel = ProductViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(productViewModel)
        }
    }
}
