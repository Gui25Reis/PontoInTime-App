/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UITableViewCell
import class UIKit.NSCoder

import UIKit

/// Célula geral de uma table que utiliza os componentes nativos de uma célula
class GeneralTableCell: UITableViewCell, CustomTableCell {
    
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
        
        content.text = data.primaryText
        content.secondaryText = data.secondaryText
        
        self.accessoryType = data.rightIcon
        self.contentConfiguration = content
    }
    
    
    public func setupCellAction(wit action: CellAction) {
        var content = self.defaultContentConfiguration()
        
        content.text = action.actionTitle
        content.textProperties.color = action.actionType.color
        
        self.contentConfiguration = content
    }
}
