/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIAlertController
import class UIKit.UIViewController


extension UIViewController: AlertHandler {
    
    public func showAlert(_ alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}
