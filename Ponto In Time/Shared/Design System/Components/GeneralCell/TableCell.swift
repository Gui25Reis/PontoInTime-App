/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
//import class Foundation.NSCoder
//import class UIKit.UIColor
//import class UIKit.UIImage
//import class UIKit.UIImageView
//import class UIKit.UITableViewCell
//import class UIKit.UIView

import UIKit


struct TableData {
    
    /* MARK: - Atributos */
    
    /// Texto principal, que fica na esquerda
    public var primaryText: String?
    
    /// Texto secundário, que fica na direita
    public var secondaryText: String?
    
    /// Imagem que acompanha o texto principal
    public var leftIcon: UIImage?
    
    /// Ícone direito (no fim da célula) padrão da célula
    public var rightIcon: TableIcon?
    
    /// Boleano que indica se a célula é editável
    public var isEditable: Bool
    
    /// Boleano que indica se possui uma switch
    public var hasSwitch: Bool
    
    /// Menu de ações
    public var menu: UIMenu?
    
    
    init() {
        self.primaryText = nil
        self.secondaryText = nil
        self.leftIcon = nil
        self.rightIcon = nil
        self.isEditable = false
        self.hasSwitch = false
        self.menu = nil
    }
}



/// Célula geral de uma table que utiliza os componentes nativos de uma célula
class TableCell: UITableViewCell, ViewCode, CustomTableCell, CustomCell {
    
    /* MARK: - Atributos */
    
    /* Views */
    
    /// Texto principal (titulo) - texto da esquerda
    private let primaryLabel: UILabel = {
        let lbl = CustomViews.newLabel(align: .left)
        lbl.sizeToFit()
        return lbl
    }()
    
    /// Texto secundário (descrição) - texto da direita
    private let secondaryText: UITextField = {
        let txt = CustomViews.newTextField()
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
    
    
    // Protocolos
    
    static var identifier: String = "IdTableCell"
    
    
    /// Diz se possui uma imagem no canto direito da célula
    internal var hasRightIcon = false
    
    internal var dynamicConstraints: [NSLayoutConstraint] = []
    
    
    // Espaço lateral
    
    private var lateral: CGFloat = 16
    
    
    //
    public var tableData = TableData() {
        didSet {
            self.createView()
        }
    }
    
    
    /* MARK: - Construtor */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        self.createView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    
    
    /* MARK: - Protocolo */
    
    internal func setupCellData(with data: TableCellData) {
        
    }
    
    
    internal func setupCellAction(with action: TableCellAction) {
//        var content = self.defaultContentConfiguration()
//
//        content.text = action.actionTitle
//        content.textProperties.color = action.actionType.color
//
//        self.contentConfiguration = content
    }
    
    
    private func setupCell() {
        let data = self.tableData
        
        self.primaryLabel.text = data.primaryText
        self.secondaryText.text = data.secondaryText
        self.leftIcon.image = data.leftIcon
        
        self.setupRightIcon(for: data.rightIcon)
        self.mainButton.menu = data.menu
        
        self.secondaryText.isUserInteractionEnabled = data.isEditable
    }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Limpa as configurações da célula
    public func clearCell() {
        self.hasRightIcon = false
        self.removeAllChildren()
    }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public override func prepareForReuse() {
        self.clearCell()
    }
    
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    /* MARK: - Protocolo */

    internal func setupHierarchy() {
        let data = self.tableData
        
        self.check(data: data.leftIcon, for: self.leftIcon)
        self.check(data: data.primaryText, for: self.primaryLabel)
        
        if data.hasSwitch {
            self.check(data: "", for: self.switchButton)
        } else {
            self.check(data: data.rightIcon, for: self.rightIcon)
            self.check(data: data.secondaryText, for: self.secondaryText)
        }
        
        self.check(data: data.menu, for: self.mainButton)
        
        self.contentView.addSubview(self.primaryLabel)
        self.primaryLabel.backgroundColor = .blue
    }
    
    
    internal func setupView() {
        self.backgroundColor = .black//UIColor(.tableColor)
    }
    
    
    internal func setupStaticConstraints() {
        let space = self.lateral/2
        var staticConstraints: [NSLayoutConstraint] = []
        
        /* Lado esquerdo */
        if self.leftIcon.hasSuperview {
            let imageView: CGFloat = 20
            staticConstraints += [
                self.leftIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                self.leftIcon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                self.leftIcon.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: self.lateral),
                self.leftIcon.widthAnchor.constraint(equalToConstant: imageView),
            ]
        }
        
        if self.primaryLabel.hasSuperview {
//            staticConstraints += [
//                self.primaryLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//                self.primaryLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
//            ]
//
//            if self.leftIcon.hasSuperview {
//                staticConstraints += [
//                    self.primaryLabel.leftAnchor.constraint(equalTo: self.leftIcon.rightAnchor, constant: space),
//                ]
//            } else {
//                staticConstraints += [
//                    self.primaryLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: self.lateral),
//                ]
//            }
        }
        
        
        /* Lado direito */
        if self.tableData.hasSwitch {
            staticConstraints += [
                self.switchButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                self.switchButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -self.lateral),
            ]
        } else {
            if self.rightIcon.hasSuperview {
                let imageSize: CGFloat = 10
                staticConstraints += [
                    self.rightIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                    self.rightIcon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                    self.rightIcon.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -self.lateral),
                    self.rightIcon.widthAnchor.constraint(equalToConstant: imageSize),
                ]
            }
            
            
            if self.secondaryText.hasSuperview {
                staticConstraints += [
                    self.secondaryText.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                    self.secondaryText.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                ]
                
                if self.rightIcon.hasSuperview {
                    staticConstraints += [
                        self.secondaryText.rightAnchor.constraint(equalTo: self.rightIcon.leftAnchor, constant: -space),
                    ]
                } else {
                    staticConstraints += [
                        self.secondaryText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -self.lateral),
                    ]
                }
                
                if self.primaryLabel.hasSuperview {
                    staticConstraints += [
                        self.secondaryText.leftAnchor.constraint(equalTo: self.primaryLabel.rightAnchor, constant: space),
                    ]
                } else {
                    staticConstraints += [
                        self.secondaryText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: self.lateral),
                    ]
                }
            }
        }
        
        
        if self.mainButton.hasSuperview {
            let buttonContraints = self.mainButton.strechToBounds(of: self.contentView)
            staticConstraints +=  buttonContraints
        }
        
        
        let constraints = self.primaryLabel.strechToBounds(of: self.contentView)
        NSLayoutConstraint.activate(constraints)
    }
    
      
    internal func setupDynamicConstraints() {
        
    }
    
    
    internal func setupUI() {}
    
    internal func setupStaticTexts() {}
    
    internal func setupFonts() {}
    
    
    
    /* MARK: - Configurações */
    
    /// Configura a imagem da direita da célula de acordo com a configuração passada
    /// - Parameter icon: tipo de ícone
    private func setupRightIcon(for icon: TableIcon?) {
        guard let icon else { return }
        
        switch icon {
        case .chevron:
            let image = UIImage.getImage(with: IconInfo(
                icon: .chevron, size: 13
            ))
            
            self.rightIcon.tintColor = .systemGray
            self.rightIcon.image = image
            
        case .contextMenu:
            let image = UIImage.getImage(with: IconInfo(
                icon: .options, size: 13
            ))
            
            self.rightIcon.tintColor = .systemGray
            self.rightIcon.image = image
            
        case .delete:
            let image = UIImage.getImage(with: IconInfo(
                icon: .delete, size: 15
            ))
            
            self.rightIcon.tintColor = .systemRed
            self.rightIcon.image = image
        }
    }
    
    
    private func check(data: Any?, for view: UIView) {
        guard data != nil else { return }
        self.contentView.addSubview(view)
    }
    
    /// Remove todos os compontentes
    private func removeAllComponents() {
        self.contentView.removeAllChildren()
    }
}
