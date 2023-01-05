/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Célula geral de uma table que utiliza os componentes nativos de uma célula
class TableCell: UITableViewCell, ViewCode, CustomCell {
    
    /* MARK: - Atributos */
    
    /* Views */
    
    /// Texto principal (titulo) - texto da esquerda
    public let primaryLabel: UILabel = {
        let lbl = CustomViews.newLabel(align: .left)
        lbl.textColor = .label
        lbl.sizeToFit()
        return lbl
    }()
    
    /// Texto secundário (descrição) - texto da direita
    private let secondaryText: UITextField = {
        let txt = CustomViews.newTextField()
        txt.textColor = .secondaryLabel
        txt.textAlignment = .right
        txt.adjustsFontSizeToFitWidth = true
        txt.isUserInteractionEnabled = false
        return txt
    }()
    
    /// Imagem que acompanha o texto principal
    private let leftIcon = CustomViews.newImage()
    
    /// Imagem que acompanha o texto secundário
    private let rightIcon = CustomViews.newImage()
    
    /// Switch da célula
    private let switchButton: UISwitch = {
        let but = CustomViews.newSwitch()
        but.isOn = true
        return but
    }()
    
    /// Botào usado para mostra o menu de açòes
    private let mainButton = CustomButton()
    
    
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
    
    /// Espaço lateral usado dentro da célula
    public var lateralSpace: CGFloat = 16
    
    /// Espaço lateral menor usado na célula entre os elementos
    public var smallLateralSpace: CGFloat { return self.lateralSpace/2 }
    
    
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
    
    
    /// Artiva (deixa focado) o text field
    public func setFocusOnTextField() {
        guard let data = self.tableData else { return }
        
        guard data.isEditable && data.menu == nil else { return }
        self.secondaryText.becomeFirstResponder()
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
        } else {
            self.check(data: data.rightIcon, for: self.rightIcon)
            self.check(data: data.secondaryText, for: self.secondaryText)
        }
        
        self.check(data: data.menu, for: self.mainButton)
    }
    
    
    internal func setupView() {
        self.backgroundColor = UIColor(.tableColor)
    }
    

    internal func setupDynamicConstraints() {
        guard self.hasData else { return }
        
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
        self.dynamicConstraints.removeAll()
        
        self.dynamicConstraints += self.setupLeftComponents()
        self.dynamicConstraints += self.setupRightComponents()
        
        if self.mainButton.hasSuperview {
            let buttonContraints = self.mainButton.strechToBounds(of: self.contentView)
            self.dynamicConstraints += buttonContraints
        }
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
    
    
    internal func setupFonts() {
        let font = FontInfo(fontSize: 18, weight: .regular)
        
        self.primaryLabel.setupFont(with: font)
        self.secondaryText.setupFont(with: font)
    }
    
    
    internal func setupStaticConstraints() {}
    
    internal func setupUI() {}
    
    internal func setupStaticTexts() {}
    
    
    
    /* MARK: - Configurações */
    
    /* Dados */
    
    /// Configura a célula
    private func setupCell() {
        guard let data = self.tableData else { return }
        self.setupData(with: data)
        self.createView()
        self.dynamicCall()
    }
    
    
    /// Configrua os dados da célula
    /// - Parameter data: dados da célula
    private func setupData(with data: TableData) {
        self.primaryLabel.text = data.primaryText
        self.secondaryText.text = data.secondaryText
        self.leftIcon.image = data.leftIcon
        
        self.setupRightIcon(for: data.rightIcon)
        self.mainButton.menu = data.menu
        
        self.secondaryText.isUserInteractionEnabled = data.isEditable
        
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
    
    
    /// Configura a imagem da direita da célula de acordo com a configuração passada
    /// - Parameter icon: tipo de ícone
    private func setupRightIcon(for icon: TableIcon?) {
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
        let space = self.smallLateralSpace
        
        if self.tableData?.hasSwitch == true {
            constraints += [
                self.switchButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                self.switchButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -lateral),
            ]
            return constraints
            
        }
        
        if self.rightIcon.hasSuperview {
            constraints += [
                self.rightIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                self.rightIcon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                self.rightIcon.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -lateral),
            ]
        }
        
        if self.secondaryText.hasSuperview {
            constraints += [
                self.secondaryText.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                self.secondaryText.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            ]
            
            if self.primaryLabel.hasSuperview {
                constraints += [
                    self.secondaryText.leftAnchor.constraint(equalTo: self.primaryLabel.rightAnchor, constant: space),
                ]
            } else {
                constraints += [
                    self.secondaryText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: lateral),
                ]
            }
            
            
            if self.rightIcon.hasSuperview {
                constraints += [
                    self.secondaryText.rightAnchor.constraint(equalTo: self.rightIcon.leftAnchor, constant: -space),
                ]
            } else {
                constraints += [
                    self.secondaryText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -lateral),
                ]
            }
        }
    
        return constraints
    }
}
