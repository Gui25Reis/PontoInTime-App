/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Data source das collections da página de menu
class InfoMenuDataSource: NSObject, TableDataCount {
    
    /* MARK: - Atributos */

    /// Dados usados no data source referente as informações do dia
    public lazy var infosData: [PointInfo] = [
        PointInfo(title: "Data", description: "16/10/22"),
        PointInfo(title: "Entrada", description: "09:41"),
        PointInfo(title: "Saída", description: "18:41")
    ]
    
    /// Dados usados no data source referente aos pontos
    public lazy var pointsData: [PointInfo] = [
        PointInfo(status: .start, title: "Trabalho", description: "09:41"),
        PointInfo(status: .start, title: "Almoço", description: "12:12"),
        PointInfo(status: .end, title: "Almoço", description: "13:10"),
        PointInfo(status: .start, title: "Trabalho", description: "09:41"),
        PointInfo(status: .start, title: "Almoço", description: "12:12"),
        PointInfo(status: .end, title: "Almoço", description: "13:10")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfosMenuCell.identifier, for: indexPath) as? InfosMenuCell else {
            return UITableViewCell()
        }
        
        switch tableView.tag {
        case 0:
            let data = self.infosData[indexPath.row]
            cell.setupCell(for: data)

            return cell
            
        case 1:
            if indexPath.row < self.pointsData.count {
                let data = self.pointsData[indexPath.row]
                cell.setupCell(for: data)
            } else {
                if indexPath.row == self.actionIndex {
                    cell.setupCell(for: nil, with: .action)
                } else {
                    cell.setupCell(for: nil, with: .destructive)
                }
            }
            
            return cell
            
            
        default:
            return UITableViewCell()
        }
    }
}
