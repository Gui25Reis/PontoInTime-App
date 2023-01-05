/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Handler da tabela da página de ajustes
class SettingsTableHandler: NSObject, TableHandler {
    
    /* MARK: - Atributos */
    
    /* Dados */
    
    /// Dados usados no data source referente as informações das informações gerais
    private lazy var infoData: [TableCellData] = []
    
    /// Dados usados no data source referente as informações de compartilhamento
    private lazy var shareData: [TableCellData] = []
    
    /// Dados usados no data source referente aos tipos de pontos
    private lazy var pointData: [ManagedPointType] = []
    
    
    /* Geral */
    
    /// Diz se está compartilhando os dados
    private var isSharing: Bool = false
    
    /// Index da célula de adicionar
    public var actionIndex: Int {
        return self.pointData.count
    }
    
        
    
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
        table.registerCell(for: SettingsCell.self)
        table.registerCell(for: TableCell.self)
    }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Dados usados dos ajustes
    public var mainData: SettingsData? {
        didSet {
            self.setupDatas()
        }
    }
    
    
    
    /* MARK: - Data Source */
    
    /* MARK: Dados */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 44
        default:
            return tableView.estimatedRowHeight
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getDataCount(for: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as? SettingsCell else {
//            return UITableViewCell()
//        }
        
        switch indexPath.section {
        
        case 0: // infos gerais
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell
            
            let data = self.infoData[indexPath.row]
            
            var tableData = TableData()
            tableData.primaryText = data.primaryText
            tableData.secondaryText = "8daslfjkhajhnfgsdghsdfgfsdgdfsnhhh"
            tableData.leftIcon = UIImage(.calendar)
            tableData.rightIcon = .contextMenu
            tableData.isEditable = true
            
            cell?.tableData = tableData
            return cell ?? UITableViewCell()
            
            //cell.setupCellData(with: data)
            
    
        case 1: // compartilhamento
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as? SettingsCell else {
                return UITableViewCell()
            }
            
            let data = self.shareData[indexPath.row]
            cell.setupCellData(with: data)
            
            if indexPath.row == 1 {
                cell.updateSwitchVisibility(for: true)
                cell.updateSwitchStatus(for: self.isSharing)
            }
            
            return cell
    
            
        case 2: // pontos
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as? SettingsCell else {
                return UITableViewCell()
            }
            
            if indexPath.row < self.pointData.count {
                let data = self.pointData[indexPath.row]
                
                var cellData = TableCellData(primaryText: data.title)
                if !data.isDefault {
                    cellData.rightIcon = .chevron
                }
                cell.setupCellData(with: cellData)
                
                return cell
            }
            
            cell.setupCellAction(with: TableCellAction(
                actionType: .action, actionTitle: "Novo"
            ))
            
            return cell
        
        default:
            break
        }
        return UITableViewCell()
    }
    
    
    
    /* MARK: Header & Footer */
    
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
                TableCellData(primaryText: "Horas de trabalho", secondaryText: settings.timeWork)
            ]
            
            self.shareData = [
                TableCellData(primaryText: "Seu ID", secondaryText: settings.sharingID),
                TableCellData(primaryText: "Compartilhar saída")
            ]
            self.isSharing = settings.isSharing
        }
        
        self.pointData = self.mainData?.pointTypeData ?? []
    }
}
