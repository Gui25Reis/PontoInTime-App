/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIAlertController
import class UIKit.UIAlertAction


extension UIAlertController {
    
    /// Adiciona um conjunto de ações
    /// - Parameter actions: conjunto de ações
    public func addActions(_ actions: [UIAlertAction]) {
        actions.forEach() { self.addAction($0) }
    }
}
