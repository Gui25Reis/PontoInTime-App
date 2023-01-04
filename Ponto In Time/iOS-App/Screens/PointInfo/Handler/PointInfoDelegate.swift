/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Delegate das tabelas de informação de um ponto
class PointInfoDelegate: NSObject, UITableViewDelegate {
    
    /* MARK: - Atributos */
    
    /// Protocolo de comunicação com a controller
    public var pointInfoProtocol: PointInfoProtocol?
    
    
    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        let customIndexPath = IndexPath(row: indexPath.row, section: tableView.tag)
        self.pointInfoProtocol?.cellSelected(at: customIndexPath)
				
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
}
