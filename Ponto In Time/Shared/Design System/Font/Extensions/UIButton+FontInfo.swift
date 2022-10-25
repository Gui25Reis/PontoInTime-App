/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIButton
import class UIKit.UIFont


extension UIButton {
    
    /// Configura a fonte e texto do botão a partir da configuração passada
    /// - Parameter config: Modelo de informações do texto e fonte
    internal func setupText(with config: FontInfo) {
        if let text = config.text {
            self.setTitle(text, for: .normal)
        }
        self.titleLabel?.font = UIFont.setupFont(with: config)
    }
}
