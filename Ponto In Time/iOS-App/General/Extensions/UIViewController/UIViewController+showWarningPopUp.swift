/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIViewController


extension UIViewController {
    
    /// Mostra o pop up em casos de erro
    /// - Parameter error: erro pra ser mostrado
    public func showWarningPopUp(with error: ErrorWarnings?) {
        guard let alert = error?.getWarningAlert() else { return }
        self.showAlert(alert)
    }
}
