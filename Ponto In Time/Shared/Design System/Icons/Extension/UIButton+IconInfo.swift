/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


extension UIButton {
    
    /// Configura o ícone do botão a partir da configuração passada
    /// - Parameter config: Modelo de informações do texto e fonte
    internal func setupIcon(with config: IconInfo) -> Void {
        let image = UIImage.getImage(with: config)
        self.setImage(image, for: .normal)
    }
}
