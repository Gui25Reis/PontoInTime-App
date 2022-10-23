/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elemento de UI da célula das tabelas da tela de informações de um ponto
class PointInfoCell: GeneralTableCell, CustomCell {
    
    /* MARK: - Atributos */
    
    /* Views */
    
    /// Tipo do ponto
    private lazy var statusView = StatusView()
    
    /// Escolha da hora
    private lazy var hourPicker = CustomViews.newDataPicker(mode: .time)
    
    /// Botão que mostra o context menu
    private lazy var menuButton: CustomButton = {
        let but = CustomButton()
        but.showsMenuAsPrimaryAction = true
        return but
    }()
    
    
    /* Outros */
    
    /// Define se vai ter o context menu
    private var hasMenu = false {
        didSet {
            self.setupButtonConstraints()
        }
    }

    
    
    /* MARK: - Construtor */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Protocolo */
    
    static var identifier: String = "IdPointInfoCell"
    
    
    
    /* MARK: - Encapsulamento */
    
    /* Picker */
    
    /// Configura a célula para caso tenha um picker
    public var isTimePicker = false {
        didSet {
            self.setupHourPicker()
        }
    }
    
    
    /// Define a ação picker
    public func setTimerAction(target: Any?, action: Selector) -> String {
        self.hourPicker.addTarget(target, action: action, for: .valueChanged)
        return self.hourPicker.date.getDateFormatted(with: .hm)
    }
    
    
    /* Status */
    
    /// Configura o tipo de status do ponto
    public var statusCell: StatusViewStyle = .start {
        didSet {
            self.setupStatusView(with: self.statusCell)
        }
    }
    
    
    /* Menu */
    
    /// Configura o context menu da célula
    /// - Parameter menu: context menu
    public func setMenuCell(for menu: UIMenu) {
        self.hasMenu = true
        self.menuButton.menu = menu
    }
    
    
    /// Define a hora que vai aparecer no timer
    /// - Parameter time: hora
    public func setTimerPicker(time: String) {
        if let date = Date.getDate(with: time, formatType: .hm) {
            self.hourPicker.timeZone = TimeZone(abbreviation: "GMT-3")
            self.hourPicker.date = date
        }
    }
    
    
    
    /* MARK: - Override */
    
    override func clearCell() {
        super.clearCell()
        
        self.menuButton.removeFromSuperview()
        self.statusView.removeFromSuperview()
        self.hourPicker.removeFromSuperview()
    }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.clearCell()
    }
    
    
    
    /* MARK: - Configurações */

    /// Configura a view de status de um ponto
    /// - Parameter status: status
    private func setupStatusView(with status: StatusViewStyle) {
        self.statusView.status = status
        
        var lateral: CGFloat = 8
        if !self.hasRightIcon {
            lateral *= 2
        }
        self.setupConstraint(for: self.statusView, with: lateral)
    }
    
    
    /// Configura a view de picker
    private func setupHourPicker() {
        self.setupConstraint(for: self.hourPicker, with: 18)
    }
    
    
    /// Adiciona o elemento na tela e define as constraints
    /// - Parameters:
    ///   - view: view que vai ser configurada
    ///   - constant: espaço lateral
    private func setupConstraint(for view: UIView, with constant: CGFloat) {
        self.contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -constant),
            view.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    
    /// Define as contraints do botão do menu
    private func setupButtonConstraints() {
        self.contentView.addSubview(self.menuButton)
        
        NSLayoutConstraint.activate([
            self.menuButton.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.menuButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.menuButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.menuButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
