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
    
    
    /// Cria o aviso de deletar o arquivo
    /// - Parameter action: ação do botão de deletar
    /// - Returns: pop up de aviso
    static func createDeleteAlert(title: String? = nil, message: String, buttonTitle: String? = nil, deleteAction action: @escaping () -> Void) -> UIAlertController {
        let menu = UIAlertController(
            title: title ?? "Tem certeza?", message: message, preferredStyle: .alert
        )
        
        let delete = UIAlertAction(title: buttonTitle ?? "Excluir", style: .destructive) { _ in action() }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        menu.addActions([delete, cancel])
        return menu
    }
    
    
    static func createSimpleAlert(title: String? = nil, message: String, deleteAction action: @escaping () -> Void) -> UIAlertController {
        let menu = UIAlertController(title: title ?? "Aviso", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        menu.addAction(okButton)
        return menu
    }
}
