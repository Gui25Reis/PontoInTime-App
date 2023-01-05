/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UITextField
import class UIKit.UIFont


extension UITextField {
    
    /// Configura a fonte e texto do text field a partir da configuração passada
    /// - Parameter config: Modelo de informações do texto e fonte
    internal func setupFont(with config: FontInfo) {
        if let text = config.text {
            self.text = text
        }
        self.font = UIFont.setupFont(with: config)
    }
}
