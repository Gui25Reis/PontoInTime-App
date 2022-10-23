/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import UIKit


/// O que essa classe faz?
class InfoMenuDelegate: NSObject, UITableViewDelegate {
    
    /* MARK: - Atributos */
    
    /// Protocolo de comunicação com a tela de menu
    public var menuControllerProtocol: MenuControllerProtocol?
        

    
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
        let customIndexPath = IndexPath(row: indexPath.row, section: tableView.tag)
        self.menuControllerProtocol?.cellClicked(at: customIndexPath)
				
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
}
