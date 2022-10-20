/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIImage
import class UIKit.UITableViewCell


/// Modelos de dados para célula padrão das tebles
struct CellData {
    
    /* MARK: - Atributos */
    
    /// Texto principal, que fica na esquerda
    let primaryText: String
    
    /// Texto secundário, que fica na direita
    let secondaryText: String
    
    /// Imagem que acompanha o texto principal
    var image: UIImage?
    
    /// Ícone direito (no fim da célula) padrão da célula
    var rightIcon: UITableViewCell.AccessoryType
    
    
    
    /* MARK: - Construtor */
    
    init(primaryText: String, secondaryText: String, image: UIImage? = nil, rightIcon: UITableViewCell.AccessoryType = .none) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = image
        self.rightIcon = rightIcon
    }
    
    
    init(primaryText: String, secondaryText: String, rightIcon: UITableViewCell.AccessoryType) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = nil
        self.rightIcon = rightIcon
    }
}
