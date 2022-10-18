/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


extension UITextField {
    
    /// Configura a fonte e texto do text field a partir da configuração passada
    /// - Parameter config: Modelo de informações do texto e fonte
    internal func setupText(with config: FontInfo) {
        if let text = config.text {
            self.text = text
        }
        
        self.font = UIFont.setupFont(with: config)
    }
}
