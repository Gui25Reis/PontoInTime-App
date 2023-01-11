/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Célula costumizada de uma tabela que imita o memso comportamento de uma célula padrão iOS
class TableCell: UITableViewCell, ViewCode, CustomCell {
    
    /* MARK: - Atributos */
    
    /* Views */
    
    /// Texto principal (titulo) - texto da esquerda
    internal lazy var primaryLabel: UILabel = {
        let lbl = CustomViews.newLabel(align: .left)
        lbl.textColor = .label
        lbl.sizeToFit()
        return lbl
    }()
    
    /// Texto secundário (descrição) - texto da direita (apenas visualização)
    internal lazy var secondaryLabel: UILabel = {
        let lbl = CustomViews.newLabel(align: .right)
        lbl.textColor = .secondaryLabel
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
        
    /// Imagem que acompanha o texto principal
    internal lazy var leftIcon = CustomViews.newImage()
    
    /// Imagem que acompanha o texto secundário
    internal lazy var rightIcon = CustomViews.newImage()
    
    /// Switch da célula
    internal lazy var switchButton: UISwitch = CustomViews.newSwitch()
    
    /// Date picker da célula
    internal lazy var datePicker = CustomViews.newDataPicker(mode: .time)
    
    /// Botão usado para mostra o menu de ações
    internal lazy var menuButton = CustomButton()
    
    
    /* Protocolos */
    
    // Custom Cell
    static var identifier: String = "IdTableCell"
    
    // View Code
    internal var dynamicConstraints: [NSLayoutConstraint] = []
    
    
    
    /* MARK: - Construtor */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    
    
    /* MARK: - Encapsulamento */
    
    /* Atributos */
    
    // Espaçamentos
    
    /// Espaço lateral (das bordas)
    public var lateralSpace: CGFloat = 16
    
    /// Espaço entre os elementos
    public var betweenSpace: CGFloat { return self.lateralSpace/2 }
    
        
    // Dados
    
    /// Dados da tabela
    public var tableData: TableData? {
        didSet { self.setupCell() }
    }
    
    /// Boleano que indica se possui dados na célula
    public var hasData: Bool { return self.tableData != nil }
    
    /// Estado do switch
    public var switchStatus = false {
        didSet { self.switchButton.isOn = self.switchStatus }
    }
    
    
    /* Métodos */
    
    /// Limpa as configurações da célula
    public func clearCell() {
        self.contentView.removeAllChildren()
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
        self.dynamicConstraints.removeAll()
        
        self.tableData = nil
        self.primaryLabel.textColor = .label
    }
    
    
    // Picker
    
    /// Define a hora que vai aparecer no timer
    /// - Parameter time: hora
    public func setTimerPicker(time: String) {
        guard let date = Date.getDate(with: time, formatType: .hm) else { return }
        self.datePicker.date = date
    }
    
    
    /// Define a ação picker
    public func setTimerAction(target: Any?, action: Selector) {
        self.datePicker.addTarget(target, action: action, for: .valueChanged)
    }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public override func prepareForReuse() {
        self.clearCell()
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.dynamicCall()
    }
    
    
    
    /* MARK: - Protocolo */

    // View Code
    
    internal func setupHierarchy() {
        guard let data = self.tableData else { return }
        
        self.check(data: data.leftIcon, for: self.leftIcon)
        self.check(data: data.primaryText, for: self.primaryLabel)
        
        if data.hasSwitch {
            self.check(data: "", for: self.switchButton)
        } else if data.hasPicker {
            self.check(data: "", for: self.datePicker)
        } else {
            self.check(data: data.rightIcon, for: self.rightIcon)
            self.check(data: data.secondaryText, for: self.secondaryLabel)
        }
        
        self.check(data: data.menu, for: self.menuButton)
    }
    
    
    internal func setupView() {
        self.backgroundColor = UIColor(.tableColor)
    }
    
    
    internal func setupFonts() {
        let font = FontInfo(fontSize: 18, weight: .regular)
        let secondFont = FontInfo(fontSize: 17, weight: .regular)
        
        self.primaryLabel.setupFont(with: font)
        self.secondaryLabel.setupFont(with: secondFont)
    }
    
    
    internal func setupStaticConstraints() {
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
        self.dynamicConstraints.removeAll()
        
        self.dynamicConstraints += self.setupLeftComponents()
        self.dynamicConstraints += self.setupRightComponents()
        
        if self.menuButton.hasSuperview {
            let buttonContraints = self.menuButton.strechToBounds(of: self.contentView)
            self.dynamicConstraints += buttonContraints
        }
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
    
    
    internal func setupUI() {}
    
    internal func setupStaticTexts() {}
    
    internal func setupDynamicConstraints() {}
    
    
    
    /* MARK: - Configurações */
    
    /* Dados */
    
    /// Configura a célula
    private func setupCell() {
        guard let data = self.tableData else { return }
        self.setupData(with: data)
        self.createView()
        self.dynamicCall()
        
        /* TODO: Desabilitando a interação (MVP: não tem feature de compartilhar) */
        self.switchButton.isUserInteractionEnabled = false
    }
    
    
    /// Configrua os dados da célula
    /// - Parameter data: dados da célula
    internal func setupData(with data: TableData) {
        self.primaryLabel.text = data.primaryText
        self.leftIcon.image = data.leftIcon
        
        self.secondaryLabel.text = data.secondaryText
        self.setupRightIcon(for: data.rightIcon)
        
        self.menuButton.menu = data.menu
        
        if let action = data.action {
            self.primaryLabel.textColor = action.color
        }
    }
    
    
    /* Geral */
    
    /// Verifica se é possível adicionar uma view a partir de um dado
    /// - Parameters:
    ///   - data: dado de verificação
    ///   - view: view que vai ser adicionada
    private func check(data: Any?, for view: UIView) {
        guard data != nil else { return }
        self.contentView.addSubview(view)
    }
    
    
    /// Configura a imagem da direita da célula de acordo com o itpo de ícone da tabela
    /// - Parameter icon: tipo de ícone
    internal func setupRightIcon(for icon: TableIcon?) {
        guard let icon else { return }
        
        var image: UIImage? = nil
        var color: UIColor = .systemGray
        
        switch icon {
        case .chevron:
            image = UIImage.getImage(with: IconInfo(icon: .chevron, size: 13))
            
        case .contextMenu:
            image = UIImage.getImage(with: IconInfo(icon: .options, size: 13))
            
        case .delete:
            image = UIImage.getImage(with: IconInfo(icon: .delete, size: 17))
            color = .systemRed
        }
        
        self.rightIcon.tintColor = color
        self.rightIcon.image = image
    }
    
    
    /* Constraints */
    
    /// Cria as contraints para os componentes do lado esquerdo da célula
    /// - Returns: constraints dos componentes
    private func setupLeftComponents() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        let lateral  = self.lateralSpace
    
        if self.leftIcon.hasSuperview {
            let imageView: CGFloat = 27
            constraints += [
                self.leftIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                self.leftIcon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                self.leftIcon.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: lateral),
                self.leftIcon.widthAnchor.constraint(equalToConstant: imageView),
            ]
        }
        
        if self.primaryLabel.hasSuperview {
            constraints += [
                self.primaryLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                self.primaryLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            ]

            if self.leftIcon.hasSuperview {
                constraints += [
                    self.primaryLabel.leftAnchor.constraint(equalTo: self.leftIcon.rightAnchor, constant: lateral),
                ]
            } else {
                constraints += [
                    self.primaryLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: lateral),
                ]
            }
        }
        
        return constraints
    }
    
    
    /// Cria as contraints para os componentes do lado direito da célula
    /// - Returns: constraints dos componentes
    private func setupRightComponents() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        let lateral = self.lateralSpace
        let space = self.betweenSpace
        
        if self.tableData?.hasSwitch == true {
            constraints += [
                self.switchButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                self.switchButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -lateral),
            ]
            return constraints
        }
        
        if self.tableData?.hasPicker == true {
            constraints += [
                self.datePicker.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                self.datePicker.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -lateral),
            ]
            return constraints
        }
        
        if self.rightIcon.hasSuperview {
            let width = CGFloat(self.rightIcon.image?.size.width ?? 0)
            constraints += [
                self.rightIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                self.rightIcon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                self.rightIcon.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -lateral),
                self.rightIcon.widthAnchor.constraint(equalToConstant: width)
            ]
        }
        
        if self.secondaryLabel.hasSuperview{
            let rightText: UIView = self.secondaryLabel
            
            constraints += [
                rightText.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                rightText.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            ]
            
            if self.primaryLabel.hasSuperview {
                constraints += [
                    rightText.leadingAnchor.constraint(equalTo: self.primaryLabel.trailingAnchor, constant: space),
                ]
            } else {
                constraints += [
                    rightText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: lateral),
                ]
            }
            
            
            if self.rightIcon.hasSuperview {
                constraints += [
                    rightText.trailingAnchor.constraint(equalTo: self.rightIcon.leadingAnchor, constant: -space),
                ]
            } else {
                constraints += [
                    rightText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -lateral),
                ]
            }
        }
    
        return constraints
    }
}
