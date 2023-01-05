/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UITextField
import class UIKit.UIFont


extension UITextField {
    
    /// Configura a fonte do text field a partir da configuração passada
    /// - Parameter config: Modelo de informações da fonte
    internal func setupFont(with config: FontInfo) {
        self.font = UIFont.setupFont(with: config)
    }
}
