/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Data source das tabelas de informações de um ponto
class PointInfoDataSource: NSObject, TableDataCount {
    
    /* MARK: - Atributos */

    /// Dados usados no data source referente as informações do ponto
    public lazy var infoData: [CellData] = [
        CellData(primaryText: "Título", secondaryText: "Nenhum"),
        CellData(primaryText: "Estado", secondaryText: ""),
        CellData(primaryText: "Horário", secondaryText: "")
    ]
    
    
    /// Dados usados no data source referente aos arquivos
    public lazy var fileData: [CellData] = [
        CellData(primaryText: "Anexo_16102022-9_41", secondaryText: ""),
    ]
    
        
    
    /* MARK: - Protocolo */
    
    func getDataCount(for dataType: Int) -> Int {
        switch dataType {
        case 0: return self.infoData.count
        case 1: return self.fileData.count+1
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointInfoCell.identifier, for: indexPath) as? PointInfoCell else {
            return UITableViewCell()
        }
        
        switch tableView.tag {
            
        case 0:
            let data = self.infoData[indexPath.row]
            cell.setupCellData(with: data)
            
            switch indexPath.row {
            case 1:
                cell.statusCell = .start
            case 2:
                cell.isTimePicker = true
            default: break
            }
        
        case 1:
            cell.hasRightIcon = false
            if indexPath.row < self.fileData.count {
                let data = self.fileData[indexPath.row]
                cell.setupCellData(with: data)
                return cell
            }
            
            cell.setupCellAction(wit: CellAction(
                actionType: .action, actionTitle: "Adicionar arquivo"
            ))
        
        default: return cell
        }
                
        return cell
    }
}
