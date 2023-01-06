/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct Foundation.IndexPath
import class Foundation.NSObject
import class UIKit.UIMenu


/// Os tipos que estão de acordo com esse protocolo são controllers da tela de
/// infomações de um ponto
protocol PointInfoProtocol: NSObject {
    
    /// Cria o context menu de acordo com a célula
    /// - Parameters:
    ///   - cell: célula que vai ser atribuida
    func createMenu(for row: Int) -> UIMenu?
    
    
    /// Atualiza a hora que o picker foi definido
    /// - Parameter time: hora do picker
    func updateTimeFromPicker(for time: String)
}
