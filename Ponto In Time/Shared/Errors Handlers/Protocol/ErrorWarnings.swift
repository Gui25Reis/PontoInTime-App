/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIAlertAction
import class UIKit.UIAlertController


/// Os tipos que estão de acordo com esse protocolo lidam com erros que podem ocorrer
/// durante a aplicação. Esse protocolo define esses possíveis erros
public protocol ErrorWarnings {
    
    /// Warnings para o usuário
    var userWarning: String { get }
    
    /// Warnings para o desenvolvedor
    var developerWarning: String { get }
}


extension ErrorWarnings {
    
    public func getWarningAlert(title: String? = nil) -> UIAlertController {
        var titleAlert = "Eita!"
        if let title {
            titleAlert = title
        }
        
        let alert = UIAlertController(
            title: titleAlert,
            message: self.userWarning,
            preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        print(self.developerWarning)
        return alert
    }
}
