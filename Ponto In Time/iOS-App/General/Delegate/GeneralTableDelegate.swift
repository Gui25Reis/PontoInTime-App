/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Delegate geral da table
class GeneralTableDelegate: NSObject, UITableViewDelegate {
    
    // TODO: Deletar quando for aplicar o delegate das tabelas
    static let shared = GeneralTableDelegate()
    
    /* MARK: - Atributos */
    
    /// Comunicação entre o delegate com ...
//    private weak var nomeProtocol: ?
        

    
    /* MARK: - Encapsulamento */
    
    /** 
        Define qual vai ser o protocolo do delegate
        - Parameter protocol: protocolo de comunicação
    */
//    public func setProtocol(with protocol: ) {
//        self.nomeProtocol = protocol
//    }
    
    
    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        // guard let protocol = self.nomeProtocol else {return}
				
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
}
