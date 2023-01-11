/* Gui Reis    -    gui.reis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIAlertController
import class Foundation.NSObject


/// Os tipos que estão de acordo com esse protocolo mostram alertas
protocol AlertHandler: NSObject {
    
    /// Mostra o pop up
    /// - Parameter alert: pop up que vai ser mostrado
    func showAlert(_ alert: UIAlertController)
}
