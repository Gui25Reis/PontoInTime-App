/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


extension UIColor {
    
    /// Cria uma cor de acordo com os casos de uso das cores do projeto
    /// - Parameter appColor: tipo de cor
    convenience init?(_ appColor: AppColors) {
        self.init(named: appColor.colorName)
    }
}
