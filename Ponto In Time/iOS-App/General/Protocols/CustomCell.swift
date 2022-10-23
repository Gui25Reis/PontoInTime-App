/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.NSObject


/// Os tipos que estão de acordo com esse protocolo são usados em células costumizadas
/// tanto de uma table quanto de um collection.
protocol CustomCell: NSObject {
    
    /// Identificador da célula
    static var identifier: String { get }
}
