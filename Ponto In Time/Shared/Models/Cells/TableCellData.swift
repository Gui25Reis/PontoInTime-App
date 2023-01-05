/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIImage
import class UIKit.UITableViewCell


/// Modelos de dados para célula padrão das tebles
struct TableCellData {
    
    /* MARK: - Atributos */
    
    /// Texto principal, que fica na esquerda
    let primaryText: String
    
    /// Texto secundário, que fica na direita
    var secondaryText: String?
    
    /// Imagem que acompanha o texto principal
    var image: UIImage?
    
    /// Ícone direito (no fim da célula) padrão da célula
    var rightIcon: TableIcon?
    
    
    
    /* MARK: - Construtor */
    
    init(primaryText: String, secondaryText: String, image: UIImage? = nil, rightIcon: TableIcon? = nil) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = image
        self.rightIcon = rightIcon
    }
    
    
    init(primaryText: String, rightIcon: TableIcon) {
        self.primaryText = primaryText
        self.secondaryText = nil
        self.image = nil
        self.rightIcon = rightIcon
    }
    
    
    init(primaryText: String, secondaryText: String, rightIcon: TableIcon) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = nil
        self.rightIcon = rightIcon
    }
    
    init(primaryText: String, secondaryText: String? = nil, image: UIImage? = nil, rightIcon: TableIcon? = nil) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = image
        self.rightIcon = rightIcon
    }
}
