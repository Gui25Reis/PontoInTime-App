/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Data source das tables da página de menu
class InfoMenuDataSource: NSObject {
    
    /* MARK: - Atributos */

    /// Se é apenas uma atualização de um dado específico
    private lazy var isUniqueUpdate = false
    
    /// Dados usados no data source referente as informações do dia
    private lazy var infosData: [TableCellData] = []
    
    /// Dados usados no data source referente aos pontosmac
    private lazy var pointsData: [TableCellData] = []
    
    
    
    /* MARK: - Encapsulamento */
    
    /* Variáveis computáveis */
    
    /// Dado que a tabela vai consumir
    public var mainData: ManagedDayWork? {
        didSet {
            if !self.isUniqueUpdate {
                self.setupDatas()
            } else {
                self.isUniqueUpdate.toggle()
            }
        }
    }
    
    /// Index da célula de adicionar
    public var actionIndex: Int {
        return self.pointsData.count-1 + 1
    }
    
    /// Index da célula de finalizar
    public var destructiveIndex: Int {
        return self.pointsData.count-1 + 2
    }
    
    
    /* Métodos */
    
    /// Adiciona um novo ponto
    /// - Parameter points: ponto
    public func updatePointsData(with points: [ManagedPoint]) {
        self.pointsData = points.map() { item in
            TableCellData(
                primaryText: item.pointType.title,
                secondaryText: item.time,
                image: StatusView.getImage(for: item.status),
                rightIcon: .chevron
            )
        }
        
        self.isUniqueUpdate = true
        self.mainData?.points = points
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
            } else {
                data.secondaryText = self.getHMFormat(for: data.secondaryText)
            }
            
            cell.setupCellData(with: data)
            return cell
            
        case 1:
            if indexPath.row < self.pointsData.count {
                var data = self.pointsData[indexPath.row]
                data.secondaryText = self.getHMFormat(for: data.secondaryText)
                
                cell.setupCellData(with: data)
                return cell
            }
            
            if indexPath.row == self.actionIndex {
                cell.setupCellAction(with: TableCellAction(
                    actionType: .action, actionTitle: "Bater novo ponto"
                ))
            } else {
                cell.setupCellAction(with: TableCellAction(
                    actionType: .destructive, actionTitle: "Finalizar o dia"
                ))
            }
            return cell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configura os dados da tabela
    private func setupDatas() {
        if let data = self.mainData {
            let calendarIcon = UIImage(.calendar)?.withTintColor(.label)
            
            self.infosData = [
                TableCellData(primaryText: "Data", secondaryText: "\(data.date)", image: calendarIcon),
                TableCellData(primaryText: "Entrada", secondaryText: "\(data.startTime)", rightIcon: .chevron),
                TableCellData(primaryText: "Saída", secondaryText: "\(data.endTime)", rightIcon: .chevron)
            ]
            
            self.updatePointsData(with: data.points)
        }
    }
    
    
    /// Pega o horário no formato HH:mm
    /// - Parameter time: horário que vai ser formatado
    /// - Returns: string com o horário
    private func getHMFormat(for time: String?) -> String {
        if let time {
            if time.count >= 5 {
                return time[0..<5]
            }
        }
        return ""
    }
}
