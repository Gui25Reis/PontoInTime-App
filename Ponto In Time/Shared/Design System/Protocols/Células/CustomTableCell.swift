/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.NSObject


/// Os tipos que estão de acordo com esse protocolo são usados em células costumizadas
/// para table
protocol CustomTableCell: NSObject {
    
    /// Configura os dados de uma célula
    /// - Parameter data: dados da célula
    func setupCellData(with data: TableCellData)
    
    
    /// Configura os dados quando for uma célula de ação
    /// - Parameter action: dados da célula
    func setupCellAction(with action: TableCellAction)
}
