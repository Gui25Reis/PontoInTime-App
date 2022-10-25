/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIImage


extension UIImage {
    
    /// Cria uma imagem a partir de um símbolo do projeto (`AppIcons`)
    /// - Parameter icon: ícone
    convenience init?(_ icon: AppIcons) {
        self.init(systemName: icon.description)
    }
    
    
    static func getImage(with config: IconInfo) -> UIImage? {
        let configIcon = UIImage.SymbolConfiguration(
            pointSize: config.size,
            weight: config.weight,
            scale: config.scale
        )
        
        return UIImage(systemName: config.icon.description, withConfiguration: configIcon)
    }
}
