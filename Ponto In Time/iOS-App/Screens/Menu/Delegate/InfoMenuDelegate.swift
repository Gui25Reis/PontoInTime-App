/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Delegate da table da tela de menu
class InfoMenuDelegate: NSObject, UITableViewDelegate {
    
    /* MARK: - Atributos */
    
    /// Protocolo de comunicação com a tela de menu
    public var menuControllerProtocol: MenuControllerProtocol?
        

    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        let customIndexPath = IndexPath(row: indexPath.row, section: tableView.tag)
        self.menuControllerProtocol?.cellSelected(at: customIndexPath)
				
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
}
