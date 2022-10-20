/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Data source das tables da página de menu
class InfoMenuDataSource: NSObject, TableDataCount {
    
    /* MARK: - Atributos */

    /// Dados usados no data source referente as informações do dia
    public lazy var infosData: [CellData] = [
        CellData(primaryText: "Data", secondaryText: "16/10/22"),
        CellData(primaryText: "Entrada", secondaryText: "09:41"),
        CellData(primaryText: "Saída", secondaryText: "18:41")
    ]
    
    /// Dados usados no data source referente aos pontos
    public lazy var pointsData: [CellData] = [
        CellData(
            primaryText: "Trabalho", secondaryText: "09:41",
            image: StatusView.getImage(for: .start), rightIcon: .disclosureIndicator
        ),
        CellData(
            primaryText: "Almoço", secondaryText: "12:12",
            image: StatusView.getImage(for: .start), rightIcon: .disclosureIndicator
        ),
        CellData(
            primaryText: "Almoço", secondaryText: "13:10",
            image: StatusView.getImage(for: .end), rightIcon: .disclosureIndicator
        ),
        CellData(
            primaryText: "Trabalho", secondaryText: "18:35",
            image: StatusView.getImage(for: .end), rightIcon: .disclosureIndicator
        )
    ]
    
    
    
    /* MARK: - Encapsulamento */
    
    public var actionIndex: Int {
        return self.pointsData.count-1 + 1
    }
    
    public var destructiveIndex: Int {
        return self.pointsData.count-1 + 2
    }
    
    
    
    /* MARK: - Protocolo */
    
    func getDataCount(for dataType: Int) -> Int {
        switch dataType {
        case 0:
            return self.infosData.count
        case 1:
            return self.pointsData.count+2
        default:
            return 0
        }
    }
    
    
    
    /* MARK: - Data Source */
    
    /// Mostra quantas células vão ser mostradas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return self.infosData.count
        }
        return self.pointsData.count + 2
    }
    
    
    /// Configura uma célula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as? MenuCell else {
            return UITableViewCell()
        }
        
        switch tableView.tag {
        case 0:
            var data = self.infosData[indexPath.row]
            if data.primaryText == "Data" {
                data.image = UIImage(.calendar)?.withTintColor(.label)
            }
            
            cell.setupCellData(with: data)
            return cell
            
        case 1:
            if indexPath.row < self.pointsData.count {
                let data = self.pointsData[indexPath.row]
                cell.setupCellData(with: data)
                return cell
            }
            
            if indexPath.row == self.actionIndex {
                cell.setupCellAction(wit: CellAction(
                    actionType: .action, actionTitle: "Bater novo ponto"
                ))
            } else {
                cell.setupCellAction(wit: CellAction(
                    actionType: .destructive, actionTitle: "Finalizar o dia"
                ))
            }
            return cell
            
            
        default: return UITableViewCell()
        }
    }
}
