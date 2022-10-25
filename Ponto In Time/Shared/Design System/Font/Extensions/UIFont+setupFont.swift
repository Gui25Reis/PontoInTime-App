/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIFont


extension UIFont {

    /// Configura a fonte de acordo com a famila que está sendo usada no projeto.
    /// - Parameter config: modelo de informações para configuração da fonte.
    /// - Returns: fonte configurada de acordo com o modelo passado.
    ///
    /// Existe uma fonte que está sendo usada para o projeto: `SF Pro Rounded`
    static func setupFont(with config: FontInfo) -> UIFont {
        let systemFont: UIFont = .systemFont(ofSize: config.fontSize, weight: config.weight)
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: config.fontSize)
        }
        return systemFont
    }
}
