/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import class UIKit.UIViewController


extension UIViewController {
    
    /// Mostra o pop up em casos de erro
    /// - Parameter error: erro pra ser mostrado
    public func showWarningPopUp(with error: ErrorCDHandler?) {
        guard let error else { return }
        let alert = CDManager.createPopUpError(error: error)
        self.present(alert, animated: true)
    }
}
