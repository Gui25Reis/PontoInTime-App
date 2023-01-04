/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.NSCoder
import class UIKit.UIColor
import class UIKit.UIImage
import class UIKit.UIImageView
import class UIKit.UITableViewCell
import class UIKit.UIView



/// Célula geral de uma table que utiliza os componentes nativos de uma célula
class GeneralTableCell: UITableViewCell, CustomTableCell {
    
    /* MARK: - Atributos */
    
    /// Diz se possui uma imagem no canto direito da célula
    internal var hasRightIcon = false
    
    
    
    /* MARK: - Construtor */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    
    
    /* MARK: - Protocolo */
    
    internal func setupCellData(with data: TableCellData) {
        var content = self.defaultContentConfiguration()
    
        content.image = data.image
        content.text = data.primaryText
        content.secondaryText = data.secondaryText
        
        self.contentConfiguration = content
        
        if let icon = data.rightIcon {
            self.setupRightIcon(for: icon)
            self.hasRightIcon = true
        }
    }
    
    
    internal func setupCellAction(with action: TableCellAction) {
        var content = self.defaultContentConfiguration()
        
        content.text = action.actionTitle
        content.textProperties.color = action.actionType.color
        
        self.contentConfiguration = content
    }
    
    
    /* MARK: - Override */
    
    override func prepareForReuse() {
        self.clearCell()
    }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Limpa as configurações da célula
    public func clearCell() {
        self.hasRightIcon = false
        
        let content = self.defaultContentConfiguration()
        self.contentConfiguration = content
        
        self.accessoryView = nil
        self.accessoryType = .none
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Personalização da UI
    private func setupUI() {
        self.backgroundColor = UIColor(.tableColor)
    }
    
    
    /// Configura a imagem da direita da célula de acordo com a configuração passada
    /// - Parameter icon: tipo de ícone
    private func setupRightIcon(for icon: TableIcon) {
        var view: UIView?
        
        switch icon {
        case .chevron:
            self.accessoryType = .disclosureIndicator
            return
            
        case .contextMenu:
            let image = UIImage.getImage(with: IconInfo(
                icon: .options, size: 13
            ))
            
            let imageView = UIImageView(image: image)
            imageView.tintColor = .systemGray
            
            view = imageView
            
        case .delete:
            let image = UIImage.getImage(with: IconInfo(
                icon: .delete, size: 15
            ))
            
            let imageView = UIImageView(image: image)
            imageView.tintColor = .systemRed
            
            view = imageView
        }
        
        self.accessoryView = view
    }
}
