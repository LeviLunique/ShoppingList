import XCTest
@testable import AddProducts

class ProductViewModelTests: XCTestCase {
    var sut: ProductViewModel!
    var persistenceController: PersistenceController!

    override func setUp() {
        super.setUp()
        // Configuração do ambiente de teste.
        // Aqui estamos criando um novo PersistenceController em memória para isolar os testes.
        persistenceController = PersistenceController(testing: true)
        sut = ProductViewModel(persistenceController: persistenceController)
    }

    override func tearDown() {
        sut = nil
        persistenceController = nil
        super.tearDown()
    }

    func testAddProduct() {
        // Definindo os valores iniciais do produto
        let initialProductName = "Product 1"
        let initialValueString = "10.0"
        let initialQuantityString = "2"

        sut.name = initialProductName
        sut.valueString = initialValueString
        sut.quantityString = initialQuantityString

        // Adiciona o produto e verifica se o produto foi adicionado com sucesso
        let expectation = self.expectation(description: "Product added")
        sut.addProduct {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)

        // Verifica se o produto foi adicionado à lista de produtos
        XCTAssertTrue(sut.productList.contains(where: { product in
            product.name == initialProductName &&
            product.value == Float(initialValueString) &&
            product.quantity == Int32(initialQuantityString)
        }), "Product was not added successfully.")
    }

    // TODO: Adicione mais testes para outras funcionalidades.
}
