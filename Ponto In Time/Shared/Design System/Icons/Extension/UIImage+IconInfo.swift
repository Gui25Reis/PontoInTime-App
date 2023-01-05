/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIImage


extension UIImage {
    
    /// Cria uma imagem a partir de um símbolo do projeto definindo as dimensòes dessa imagem
    /// - Parameter config: dimensões do ícone
    /// - Returns: imagem com o ícone e dimensões
    static func getImage(with config: IconInfo) -> UIImage? {
        let configIcon = UIImage.SymbolConfiguration(
            pointSize: config.size,
            weight: config.weight,
            scale: config.scale
        )
        
        return UIImage(systemName: config.icon.description, withConfiguration: configIcon)
    }
}
