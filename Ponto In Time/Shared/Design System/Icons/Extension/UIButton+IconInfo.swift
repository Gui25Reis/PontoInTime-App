/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIButton
import class UIKit.UIImage


extension UIButton {
    
    /// Configura o ícone do botão a partir da configuração passada
    /// - Parameter config: Modelo de informações do texto e fonte
    internal func setupIcon(with config: IconInfo) -> Void {
        let image = UIImage.getImage(with: config)
        self.setImage(image, for: .normal)
    }
}
