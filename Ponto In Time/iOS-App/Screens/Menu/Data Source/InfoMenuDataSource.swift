/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Data source das tables da página de menu
class InfoMenuDataSource: NSObject, TableDataCount {
    var reloadDataProtocol: TableReloadData?
    
    
    /* MARK: - Atributos */
    
    public var mainData: ManagedDayWork? {
        didSet {
            self.setupDatas()
        }
    }

    
    /// Dados usados no data source referente as informações do dia
    private lazy var infosData: [CellData] = []
    
    /// Dados usados no data source referente aos pontos
    private lazy var pointsData: [CellData] = []
    
    
    
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
                cell.setupCellAction(with: CellAction(
                    actionType: .action, actionTitle: "Bater novo ponto"
                ))
            } else {
                cell.setupCellAction(with: CellAction(
                    actionType: .destructive, actionTitle: "Finalizar o dia"
                ))
            }
            return cell
            
            
        default: return UITableViewCell()
        }
    }
    
    
    private func setupDatas() {
        if let data = self.mainData {
            let calendarIcon = UIImage(.calendar)?.withTintColor(.label)
            
            self.infosData = [
                CellData(primaryText: "Data", secondaryText: "\(data.date)", image: calendarIcon),
                CellData(primaryText: "Entrada", secondaryText: "\(data.startTime)", rightIcon: .chevron),
                CellData(primaryText: "Saída", secondaryText: "\(data.endTime)", rightIcon: .chevron)
            ]
            
            self.pointsData = data.points.map() { item in
                CellData(
                    primaryText: item.pointType.title,
                    secondaryText: item.time,
                    image: StatusView.getImage(for: item.status),
                    rightIcon: .chevron
                )
            }
        }
    }
}
