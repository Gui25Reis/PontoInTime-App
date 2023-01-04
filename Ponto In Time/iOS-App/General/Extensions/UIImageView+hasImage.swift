/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import class UIKit.UIImage
import class UIKit.UIImageView


extension UIImageView {
    
    /// Boleano que diz se possui uma imagem
    public var hasImage: Bool {
        return self.image != nil
    }
}
