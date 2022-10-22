/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import UIKit


/// O que essa classe faz?
class PointInfoDelegate: NSObject, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        if tableView.tag == 0 {
            return UIContextMenuConfiguration(identifier: "id" as NSString, previewProvider: nil) { _ in
                switch indexPath.row {
                case 0:
                    var actions: [UIAction] = []
                    for item in ["Trabalho", "Almoço"] {
                        let action = UIAction(title: item) {_ in }
                        actions.append(action)
                    }
                    
                    return UIMenu(title: "Pontos", children: actions)
                    
                    
                case 1:
                    var actions: [UIAction] = []
                    for item in StatusViewStyle.allCases {
                        let action = UIAction(
                            title: item.word,
                            image: StatusView.getImage(for: item)
                        ) {_ in }
                        
                        actions.append(action)
                    }
                    
                    return UIMenu(title: "Tipos", children: actions)
                    
                default:
                    break
                }
                return nil
            }
        }
        return nil
    }
}
