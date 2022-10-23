/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct UIKit.IndexPath
import class UIKit.NSObject


/// Os tipos que estão de acordo com esse protocolo são controllers da tela de
/// infomações de um ponto
protocol PointInfoProtocol: NSObject {
    
    /// Cria o context menu de acrodo com a célula
    /// - Parameters:
    ///   - cell: célula que vai ser atribuida
    func createMenu(for cell: PointInfoCell)
    
    
    /// Atualiza a hora que o picker foi definido
    /// - Parameter time: hora do picker
    func updateTimeFromPicker(for time: String)
    
    
    /// Recebe a célula da tebela que foi selecionada
    /// - Parameter indexPath: seção e linha que foi clicada
    func cellSelected(at indexPath: IndexPath)
}
