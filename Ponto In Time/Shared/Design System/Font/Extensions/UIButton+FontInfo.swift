/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIButton
import class UIKit.UIFont


extension UIButton {
    
    /// Configura a fonte do botão a partir da configuração passada
    /// - Parameter config: Modelo de informações da fonte
    internal func setupFont(with config: FontInfo) {
        self.titleLabel?.font = UIFont.setupFont(with: config)
    }
}
