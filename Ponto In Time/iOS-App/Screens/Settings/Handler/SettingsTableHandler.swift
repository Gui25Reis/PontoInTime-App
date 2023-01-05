/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Handler da tabela da página de ajustes
class SettingsTableHandler: NSObject, TableHandler {
    
    /* MARK: - Atributos */
    
    /* Dados */
    
    /// Dados usados no data source referente as informações das informações gerais
    private lazy var infoData: [TableData] = []
    
    /// Dados usados no data source referente as informações de compartilhamento
    private lazy var shareData: [TableData] = []
    
    /// Dados usados no data source referente aos tipos de pontos
    private lazy var pointData: [ManagedPointType] = []
    
    
    /* Geral */
    
    /// Diz se está compartilhando os dados
    private var isSharing: Bool = false
    
    /// Index da célula de adicionar
    public var actionIndex: Int { return self.pointData.count }
    
    /// Protocolo de comunicação com a controller da tabela
    public weak var settingProtocol: SettingsProtocol?
    
        
    
    /* MARK: - Protocolo */

    func getDataCount(for dataType: Int) -> Int {
        switch dataType {
        case 0: return self.infoData.count
        case 1: return self.shareData.count
        case 2: return self.pointData.count+1
        default: return 0
        }
    }
    
    
    func registerCell(in table: CustomTable) {
        table.registerCell(for: TableCell.self)
    }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Dados usados dos ajustes
    public var mainData: SettingsData? {
        didSet { self.setupDatas() }
    }
    
    
    
    /* MARK: - Data Source */
    
    /* MARK: Dados */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getDataCount(for: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell
        else { return UITableViewCell() }
        
        switch indexPath.section {
        
        case 0: // infos gerais
            var data = self.infoData[indexPath.row]
            data.isEditable = true
            
            cell.tableData = data
    
        case 1: // compartilhamento
            var data = self.shareData[indexPath.row]
            
            switch indexPath.row {
            case 0: // id
                data.menu = self.createCopyMenu()
                
            case 1: // switch
                data.hasSwitch = true
                cell.switchStatus = self.isSharing
                
            default: break
            }
            
            cell.tableData = data
            
        case 2: // pontos
            if indexPath.row < self.pointData.count {
                let data = self.pointData[indexPath.row]
                
                var cellData = TableData(primaryText: data.title)
                if !data.isDefault {
                    cellData.rightIcon = .chevron
                }
                
                cell.tableData = cellData
                return cell
            }
            
            var data = TableData(primaryText: "Novo")
            data.action = .action
            cell.tableData = data
        
        default: break
        }
        return cell
    }
    
    
    
    /* MARK: Header & Footer */
    
    // Header
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Compartilhamento"
        case 2:
            return "Pontos"
        default: return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1, 2:
            return tableView.estimatedSectionHeaderHeight
        default: return 0
        }
    }
    
    
    // Footer
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Compartilha apenas o seu horário, podendo ver no site do app através do seu id"
        default: return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return tableView.estimatedSectionFooterHeight
        default: return 0
        }
    }
    
    
    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        let cell = tableView.cellForRow(at: indexPath) as? TableCell
        cell?.setFocusOnTextField()
        
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadInputViews()
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configura os dados da tabela
    private func setupDatas() {
        if let settings = self.mainData?.settingsData {
            self.infoData = [
                TableData(primaryText: "Horas de trabalho", secondaryText: settings.timeWork)
            ]
            
            self.shareData = [
                TableData(primaryText: "Seu ID", secondaryText: settings.sharingID),
                TableData(primaryText: "Compartilhar saída")
            ]
            self.isSharing = settings.isSharing
        }
        
        self.pointData = self.mainData?.pointTypeData ?? []
    }
    
    
    /// Cria o context menu para a célula de mostrar os estados disponiveis
    /// - Parameter cell: célula que vai ser atribuida o menu
    private func createCopyMenu() -> UIMenu {
        let idCode = self.mainData?.settingsData?.sharingID ?? ""
        
        let action = UIAction(title: "Copiar ID") { _ in
            self.settingProtocol?.copyAction(with: idCode)
        }
        
        let menu = UIMenu(children: [action])
        return menu
    }
}
