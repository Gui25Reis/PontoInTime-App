/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIView
import class UIKit.NSLayoutConstraint


extension UIView {
    
    /// Cria as contrainsts fixando na view inteira
    /// - Parameter view: view que vai ser fixada
    /// - Returns: lista com as contraints
    ///
    /// Esse método não ativa as constraints apenas cria elas
    public func strechToBounds(of view: UIView) -> [NSLayoutConstraint] {
        let constraints = [
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        return constraints
    }
}
