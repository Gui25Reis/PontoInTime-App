/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.NSCoder
import class UIKit.UIView
import class UIKit.UITableView
import struct CoreGraphics.CGRect



/// Table costumizada
class CustomTable: UITableView {
    
    /* MARK: - Construtor */
    
    init(style: TableStyle) {
        super.init(frame: .zero, style: .insetGrouped)
        
        self.setupView(with: style)
        //self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    /// - Parameter handler: handler de acrodo com o protocolo
    public func setupTableHadler(with handler: TableHandler) {
        self.dataSource = handler
        self.delegate = handler
    }
    
    
    /// Boleano que indica se a table possui um header
    public var hasHeader = true {
        didSet {
            self.hideExtraView(isHeader: true, status: self.hasHeader)
        }
    }
    
    
    /// Boleano que indica se a table possui um footer
    public var hasFooter = true {
        didSet {
            self.hideExtraView(isHeader: false, status: self.hasFooter)
        }
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configura a view
    private func setupView(with style: TableStyle) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .systemGray6//.systemGroupedBackground
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
                
        switch style {
        case .justTable:
            self.hasHeader = false
            self.hasFooter = false
            
        case .withFooter:
            self.hasHeader = false
            
        case .withHeader:
            self.hasFooter = false
            
        default: break
        }
    }
    
    
    /// Esconde o header e/ou footer da table
    /// - Parameters:
    ///   - isHeader: boleano que indica se vai fazer alteração no header (true) ou footer (false)
    ///   - status: boleano que diz se vai fazer a alteração
    private func hideExtraView(isHeader: Bool, status: Bool) {
        guard !status else { return }
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude

        let zeroView = UIView(frame: frame)
        
        switch isHeader {
        case true:
            self.tableHeaderView = zeroView
        case false:
            self.tableFooterView = zeroView
        }
    }
}
