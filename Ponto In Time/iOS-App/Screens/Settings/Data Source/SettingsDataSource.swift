/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Data source das tables da página de ajustes
class SettingsDataSource: NSObject, TableDataCount {
    
    /* MARK: - Atributos */

    /// Dados usados no data source referente as informações das informações gerais
    public lazy var infoData: [CellData] = [
        CellData(primaryText: "Horas de trabalho", secondaryText: "8")
    ]
    
    
    /// Dados usados no data source referente as informações de compartilhamento
    public lazy var shareData: [CellData] = [
        CellData(primaryText: "Seu ID", secondaryText: "mentor"),
        CellData(primaryText: "Compartilhar saída", secondaryText: "")
    ]
    
    
    /// Dados usados no data source referente aos tipos de pontos
    public lazy var pointData: [CellData] = [
        CellData(primaryText: "Trabalho", secondaryText: ""),
        CellData(primaryText: "Almoço", secondaryText: ""),
    ]
    
        
    
    /* MARK: - Protocolo */
    
    func getDataCount(for dataType: Int) -> Int {
        switch dataType {
        case 0: return self.infoData.count
        case 1: return self.shareData.count
        case 2: return self.pointData.count+1
        default: return 0
        }
    }
    
    
    
    /* MARK: - Data Source */
    
    /// Mostra quantas células vão ser mostradas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getDataCount(for: tableView.tag)
    }
    
    
    /// Configura uma célula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        
        switch tableView.tag {
            
        case 0:
            let data = self.infoData[indexPath.row]
            cell.setupCellData(with: data)
        
        case 1:
            let data = self.shareData[indexPath.row]
            cell.setupCellData(with: data)
            
            if indexPath.row == 1 {
                cell.updateSwitchVisibility(for: true)
            }
            
        case 2:
            if indexPath.row < self.pointData.count {
                let data = self.pointData[indexPath.row]
                cell.setupCellData(with: data)
                return cell
            }
            
            cell.setupCellAction(wit: CellAction(
                actionType: .action, actionTitle: "Novo"
            ))
        
        default: return cell
        }
                
        return cell
    }
}
