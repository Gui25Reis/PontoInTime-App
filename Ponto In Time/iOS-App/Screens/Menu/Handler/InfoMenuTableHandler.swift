/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Lida (handler) com a tabela da tela de menu
class InfoMenuTableHandler: NSObject, TableHandler {
    
    /* MARK: - Atributos */
    
    /// Boleano que indica se é apenas uma atualização de um dado específico
    private lazy var isUniqueUpdate = false
    
    /// Dados usados no data source referente as informações do dia
    private lazy var infosData: [TableData] = []
    
    /// Dados usados no data source referente aos pontos
    private lazy var pointsData: [TableData] = []
    
    
    
    /* MARK: - Encapsulamento */
    
    /* Variáveis computáveis */
    
    /// Protocolo de comunicação com a tela que mostra as informações de um dia de trabalho
    public weak var dayWorkInfoDelegate: ViewWithDayWorkInfoDelegate?
    
    /// Protocolo de comunicação que apresenta um alerta
    public weak var alertHandler: AlertHandler?
    
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
    public var actionIndex: Int { return self.pointsData.count-1 + 1 }
    
    /// Index da célula de finalizar
    public var destructiveIndex: Int { return self.pointsData.count-1 + 2 }
    
    /// Index do ponto que foi selecionado
    public var pointSelectedIndex: Int?
    
    
    /* Métodos */
    
    /// Adiciona um novo ponto
    /// - Parameter points: ponto
    public func updatePointsData(with points: [ManagedPoint]) {
        self.pointsData = points.map() { item in
            TableData(
                primaryText: item.pointType?.title ?? "", secondaryText: item.time,
                image: StatusView.getImage(for: item.status), rightIcon: .chevron
            )
        }
        
        self.isUniqueUpdate = true
        self.mainData?.points = points
    }
    
    
    public func updatePoint(with data: ManagedPoint) {
        guard let index = self.pointSelectedIndex else { return }
        self.mainData?.points[index] = data
        self.pointSelectedIndex = nil
    }
    
    
    /// Deleta o último ponto selecionado
    public func deleteLastPointSelected() -> ManagedPoint? {
        guard let index = self.pointSelectedIndex else { return nil }
        let point = self.mainData?.points.remove(at: index)
        
        self.pointSelectedIndex = nil
        return point
    }
    
    
    
    /* MARK: - Protocolo */
    
    func getDataCount(for dataType: Int) -> Int { return 0 }
    
    
    func registerCell(in table: CustomTable) {
        table.registerCell(for: TableCell.self)
        table.registerCell(for: TimerCell.self)
    }
    
    
    
    /* MARK: - Data Source */
    
    /* MARK: Dados */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return tableView.superview?.getEquivalent(75) ?? 75
            
        default:
            return tableView.defaultRowHeight
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
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell
    
            var data = self.infosData[indexPath.row]
            if data.primaryText == "Data" {
                data.leftIcon = UIImage(.calendar)?.withTintColor(.label)
            } else {
                data.secondaryText = self.getHMFormat(for: data.secondaryText)
            }
            
            cell?.tableData = data
            mainCell = cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell
            
            if indexPath.row < self.pointsData.count {
                var data = self.pointsData[indexPath.row]
                data.secondaryText = self.getHMFormat(for: data.secondaryText)
                
                cell?.tableData = data
                mainCell = cell
                break
            }
            
            var data = TableData()
            if indexPath.row == self.actionIndex {
                data.primaryText = "Bater novo ponto"
                data.action = .action
                
            } else {
                data.primaryText = "Finalizar o dia"
                data.action = .destructive
            }
            
            cell?.tableData = data
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
        self.pointSelectedIndex = nil
        self.cellSelected(at: indexPath)
                
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
    
    
    // Define se é possível configurar uma ação na célula (swipe)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let isSectionAlowed = indexPath.section == 2
        let isCellAction = indexPath.row == self.actionIndex || indexPath.row == self.destructiveIndex
        return isSectionAlowed && !isCellAction
    }
    
    
    // Define a ação de swipe na célula (lado direito)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard self.tableView(tableView, canEditRowAt: indexPath) else { return nil }
        
        let delete = UIContextualAction(style: .destructive, title: "Remover") { _, _, handler in
            self.pointSelectedIndex = indexPath.row
            self.deletePointAction()
            handler(true)
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    

    /* MARK: - Configurações */
    
    /// Configura os dados da tabela
    private func setupDatas() {
        guard let data = self.mainData else { return }
        
        let calendarIcon = UIImage(.calendar)?.withTintColor(.label)
        
        self.infosData = [
            TableData(primaryText: "Data", secondaryText: "\(data.date)", image: calendarIcon),
            TableData(primaryText: "Entrada", secondaryText: "\(data.startTime)", rightIcon: .chevron),
            TableData(primaryText: "Saída", secondaryText: "\(data.endTime)", rightIcon: .chevron)
        ]
        
        self.updatePointsData(with: data.points)
    }
    
    
    /// Pega o horário no formato HH:mm
    /// - Parameter time: horário que vai ser formatado
    /// - Returns: string com o horário
    private func getHMFormat(for time: String?) -> String {
        guard let time, time.count >= 5 else { return "" }
        return time[0..<5]
    }
    
    
    /// Lida com a ação de quando a célula é selecionada
    /// - Parameter indePath: posição da célula
    private func cellSelected(at indePath: IndexPath) {
        let row = indePath.row
        
        switch indePath.section {
        case 2: // Pontos
            if row < self.actionIndex {
                let data = self.mainData?.points[row]
                self.dayWorkInfoDelegate?.showPointInfos(for: data)
                self.pointSelectedIndex = row
                return
            }
            
            if row == self.actionIndex {
                self.dayWorkInfoDelegate?.showPointInfos(for: nil)
                return
            }
            
            return print("Quer finalizar o dia")
            
        default: break
        }
    }
    
    
    /* MARK: - Ações de Botões */
    
    private func deletePointAction() {
        let message = "Tem certeza que deseja deletar o ponto?"
        let alert = UIAlertController.createDeleteAlert(message: message) {
            self.dayWorkInfoDelegate?.deletePointSelected()
        }
        self.alertHandler?.showAlert(alert)
    }
}
