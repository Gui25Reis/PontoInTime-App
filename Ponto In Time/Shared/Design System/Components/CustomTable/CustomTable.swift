/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.NSCoder
import class UIKit.UITableView


/// Table costumizada
class CustomTable: UITableView {
    
    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero, style: .insetGrouped)
        self.setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Registra uma célula costumizada na table
    /// - Parameter cell: célula costumizada
    public func registerCell<T>(for cell: T.Type) {
        if let cell = T.self as? any CustomCell.Type {
            self.register(cell.self, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    
    /// Configura o handler da tabela
    /// - Parameter handler: handler de acordo com o protocolo
    public func setupTableHadler(with handler: TableHandler) {
        self.dataSource = handler
        self.delegate = handler
    }

        
    
    /* MARK: - Configurações */
    
    /// Configura a view
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .systemGray6
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
