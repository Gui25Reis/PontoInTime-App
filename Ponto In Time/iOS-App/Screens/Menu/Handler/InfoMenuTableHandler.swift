/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Lida (handler) com a tabela da tla de menu
class InfoMenuTableHandler: NSObject, TableHandler {
    
    /* MARK: - Atributos */
    
    /// Se é apenas uma atualização de um dado específico
    private lazy var isUniqueUpdate = false
    
    /// Dados usados no data source referente as informações do dia
    private lazy var infosData: [TableCellData] = []
    
    /// Dados usados no data source referente aos pontosmac
    private lazy var pointsData: [TableCellData] = []
    
    
    
    /* MARK: - Encapsulamento */
    
    /* Variáveis computáveis */
    
    /// Protocolo de comunicação com a tela de menu
    public var menuControllerProtocol: MenuControllerProtocol?
    
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
    
    func getDataCount(for dataType: Int) -> Int { return 0 }
    
    
    func registerCell(in table: CustomTable) {
        table.registerCell(for: TimerCell.self)
        table.registerCell(for: MenuCell.self)
    }
    
    
    
    /* MARK: - Data Source */
    
    /* MARK: Dados */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return tableView.superview?.getEquivalent(75) ?? 75
            
        default:
            return tableView.estimatedRowHeight
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.infosData.count
        case 2:
            return self.pointsData.count + 2
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mainCell: UITableViewCell? = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TimerCell.identifier, for: indexPath) as? TimerCell
            mainCell = cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as? MenuCell
    
            var data = self.infosData[indexPath.row]
            if data.primaryText == "Data" {
                data.image = UIImage(.calendar)?.withTintColor(.label)
            } else {
                data.secondaryText = self.getHMFormat(for: data.secondaryText)
            }
            
            cell?.setupCellData(with: data)
            mainCell = cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as? MenuCell
            
            if indexPath.row < self.pointsData.count {
                var data = self.pointsData[indexPath.row]
                data.secondaryText = self.getHMFormat(for: data.secondaryText)
                
                cell?.setupCellData(with: data)
                mainCell = cell
                break
            }
            
            if indexPath.row == self.actionIndex {
                cell?.setupCellAction(with: TableCellAction(
                    actionType: .action, actionTitle: "Bater novo ponto"
                ))
            } else {
                cell?.setupCellAction(with: TableCellAction(
                    actionType: .destructive, actionTitle: "Finalizar o dia"
                ))
            }
            
            mainCell = cell
            
        default: break
        }
        
        return mainCell!
    }
    
    
    /* MARK: Header & Footer */
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2:
            return "PONTOS DO DIA"
            
        default: return nil
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return tableView.estimatedSectionHeaderHeight
            
        default: return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        self.menuControllerProtocol?.cellSelected(at: indexPath)
                
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
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
