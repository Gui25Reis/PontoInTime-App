/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIAlertController
import class Foundation.NSObject


/// Os tipos que estão de acordo com esse protocolo mostram todos os dados de um um dia de trablalho
protocol ViewWithDayWorkInfoDelegate: NSObject {
    
    /// Configura os dados iniciais que vão ser colocados na tabela
    /// - Parameter data: dados iniciais
    func setupInitalData(with data: ManagedPoint)
    
    
    /// Adiciona um novo ponto
    /// - Parameter data: novo ponto
    func addNewPoint(with data: ManagedPoint)
    
    
    /// Recebe informações de um ponto para abrir a página dele
    /// - Parameter data: infos de um ponto
    func showPointInfos(for data: ManagedPoint?)
    
    
    /// Atualiza um ponto que recebeu mudanças
    /// - Parameter newPoint: novo ponto
    func updatePointChanged(newPoint: ManagedPoint)
    
    
    /// Deleta um ponto que fo selecionado
    /// - Parameter point: ponto que vai ser deletado
    func deletePointSelected()
}
