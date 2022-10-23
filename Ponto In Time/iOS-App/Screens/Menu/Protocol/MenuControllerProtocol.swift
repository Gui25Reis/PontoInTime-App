/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct UIKit.IndexPath
import class UIKit.NSObject


/// Os tipos que estão de acordo com esse protocolo são controllers da tela de menu
protocol MenuControllerProtocol: NSObject {
    
    /// Configura os dados iniciais que vão ser colocados na tabela
    /// - Parameter data: dados iniciais
    func setupInitalData(with data: ManagedPoint)
    
    /// Adiciona um novo ponto
    /// - Parameter data: novo ponto
    func addNewPoint(with data: ManagedPoint)
    
    
    /// Recebe a célula da tebela que foi selecionada
    /// - Parameter indexPath: seção e linha que foi clicada
    func cellSelected(at indexPath: IndexPath)
}
