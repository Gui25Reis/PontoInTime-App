/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.NSCoder

import class UIKit.UIImage
import class UIKit.UIImageView
import class UIKit.UITableViewCell
import class UIKit.UIView



/// Célula geral de uma table que utiliza os componentes nativos de uma célula
class GeneralTableCell: UITableViewCell, CustomTableCell {
    
    /* MARK: - Atributos */
    
    internal var hasRightIcon = false
    
    
    
    /* MARK: - Construtor */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    
    
    /* MARK: - Protocolo */
    
    public func setupCellData(with data: CellData) {
        var content = self.defaultContentConfiguration()
        
        if let img = data.image {
            content.image = img
        }
        
        if let secondText = data.secondaryText {
            content.secondaryText = secondText
        }
        
        content.text = data.primaryText
        self.contentConfiguration = content
        
        if let icon = data.rightIcon {
            self.setupRightIcon(for: icon)
            self.hasRightIcon = true
        }
    }
    
    
    public func setupCellAction(with action: CellAction) {
        var content = self.defaultContentConfiguration()
        
        content.text = action.actionTitle
        content.textProperties.color = action.actionType.color
        
        self.contentConfiguration = content
    }
    
    
    
    public func clearCell() {
        self.hasRightIcon = false
        
        let content = self.defaultContentConfiguration()
        self.contentConfiguration = content
        
        self.accessoryView = nil
        self.accessoryType = .none
    }
    
    
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
