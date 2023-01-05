/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIImageView


extension UIImageView {
    
    /// Boleano que diz se possui uma imagem
    public var hasImage: Bool {
        return self.image != nil
    }
}
