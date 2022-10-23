/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


extension UILabel {
    
    /// Configura a fonte e texto da label a partir da configuração passada
    /// - Parameter config: Modelo de informações do texto e fonte
    internal func setupText(with config: FontInfo) {
        if let text = config.text {
            self.text = text
        }
        self.font = UIFont.setupFont(with: config)
    }
    
    
    /// Adiciona um ícone junto com o texto
    /// - Parameters:
    ///   - text: informações do texto
    ///   - icon: informações do ícone
    internal func setupTextWithIcon(text: FontInfo, icon: IconInfo) {
        // Texto
        let space = " "
        let textString = NSAttributedString(string: "\(space)\(text.text ?? "")")
        
        // Ícone
        let imageString = NSTextAttachment()
        imageString.image = UIImage.getImage(with: icon)

        let finalString = NSMutableAttributedString(attachment: imageString)
        finalString.append(textString)
        
        // Atribuindo configurações na label
        self.attributedText = finalString
        self.setupText(with: FontInfo(fontSize: text.fontSize, weight: text.weight))
    }
}
