/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UITextField
import protocol UIKit.UITextFieldDelegate

import class Foundation.NSObject
import struct Foundation.NSRange


/// Delegate do text field
class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    /* MARK: - Atributos */
    
    /// Máximo de caracteres permitidos
    public var maxLenght: Int?
    
    /// Comunicação com a controller
    public var delegate: ViewHasTextField?
    
    
    
    /* MARK: - Delegate */
    
    // Limita a quantidade de caracteres
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let maxLenght {
            return range.location < maxLenght
        }
        return true
    }
    
    
    // Faz com que a tecla return do teclado faça o app aceitar a entrada e o teclado abaixe
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.returnKeyType = .done
        textField.resignFirstResponder()
        self.delegate?.dismissAction()
        return true
    }
}
