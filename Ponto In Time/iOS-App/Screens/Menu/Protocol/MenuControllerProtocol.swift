/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.NSObject


/// Os tipos que estão de acordo com esse protocolo são controllers da tela de menu
protocol MenuControllerProtocol: NSObject {
    
    /// Configura os dados iniciais que vão ser colocados na tabela
    /// - Parameter data: dados iniciais
    func setupInitalData(with data: ManagedPoint)
    
    
    /// Adiciona um novo ponto
    /// - Parameter data: novo ponto
    func addNewPoint(with data: ManagedPoint)
    
    
    /// Recebe informações de um ponto para abrir a pa;gina dele
    /// - Parameter data: infos de um ponto
    func showPointInfos(for data: ManagedPoint?)
    
    
    /// Atualiza um ponto que recebeu mudanças
    /// - Parameter newPoint: novo ponto
    func updatePointChanged(newPoint: ManagedPoint?)
}
