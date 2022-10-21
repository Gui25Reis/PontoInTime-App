/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elemento de UI da célula das tabelas da tela de informações de um ponto
class PointInfoCell: GeneralTableCell, CustomCell {
    
    /* MARK: - Atributos */
    
    /// Tipo do ponto
    private lazy var statusView = StatusView()
    
    /// Escolha da hora
    private lazy var hourPicker = CustomViews.newDataPicker(mode: .time)

    
    
    /* MARK: - Construtor */
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Protocolo */
    
    static var identifier: String = "IdPointInfoCell"
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Configura a célula para caso tenha um picker
    public var isTimePicker = false {
        didSet {
            self.setupHourPicker()
        }
    }
    
    /// Configura o tipo de status do ponto
    public var statusCell: StatusViewStyle = .start {
        didSet {
            self.setupStatusView(with: self.statusCell)
        }
    }

    
    
    /* MARK: - Configurações */

    /// Configura a view de status de um ponto
    /// - Parameter status: status
    private func setupStatusView(with status: StatusViewStyle) {
        self.statusView.status = status
        self.setupConstraint(for: self.statusView, with: 8)
    }
    
    
    /// Configura a view de picker
    private func setupHourPicker() {
        self.setupConstraint(for: self.hourPicker, with: 20)
    }
    
    
    /// Adiciona o elemento na tela e define as constraints
    /// - Parameters:
    ///   - view: view que vai ser configurada
    ///   - constant: espaço lateral
    private func setupConstraint(for view: UIView, with constant: CGFloat) {
        self.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -constant),
            view.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
