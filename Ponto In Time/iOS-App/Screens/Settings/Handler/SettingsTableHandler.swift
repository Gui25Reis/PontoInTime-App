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
    
    // Protocolos
    
    /// Protocolo de comunicação com a controller da tabela
    public weak var settingProtocol: SettingsProtocol?
    
    /// Protocolo para mostrar o popup
    public weak var alertHandler: AlertHandler?
    
    
    // Geral
    
    /// Dados usados dos ajustes
    public var mainData: SettingsData? {
        didSet { self.setupDatas() }
    }
    
    /// Index da célula de adicionar
    public var actionIndex: Int { return self.pointData.count }
    
    /// Seção que foi editada
    public var cellEditedPosition: IndexPath?
    
    
    
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
        
        let row = indexPath.row
        switch indexPath.section {
        
        case 0: // infos gerais
            var data = self.infoData[row]
            data.isEditable = true
            
            cell.tableData = data
    
        case 1: // compartilhamento
            var data = self.shareData[row]
            
            switch row {
            case 0: // id
                // data.menu = self.createCopyMenu()
                break
                
            case 1: // switch
                data.hasSwitch = true
                cell.switchStatus = self.isSharing
                
            default: break
            }
            
            cell.tableData = data
            
        case 2: // pontos
            if row < self.pointData.count {
                let data = self.pointData[row]
                
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadInputViews()
        
        if indexPath.section == 1 {
            let alert = self.createInactiveWarning()
            self.alertHandler?.showAlert(alert)
            return
        }
        
        guard
            let cell = tableView.cellForRow(at: indexPath) as? TableCell,
            let data = cell.tableData
        else { return }
        
        if data.hasAction {
            let newData = TextEditData(
                title: "Pontos", isNumeric: false, maxDataLenght: 15
            )
            
            self.cellEditedPosition = indexPath
            self.settingProtocol?.openTextEditPage(for: newData)
        } else {
            self.openEditText(at: indexPath, with: data)
        }
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
    
    
    /// Abre uma página para poder editar 
    /// - Parameters:
    ///   - indexPath: posição da célula
    ///   - tableData: dado da célula
    private func openEditText(at indexPath: IndexPath, with tableData: TableData) {
        var data: TextEditData? = nil
        
        let section = indexPath.section
        switch section  {
        case 0: // horas de trabalho
            guard tableData.isEditable else { return }
            data = TextEditData(
                title: tableData.primaryText, defaultData: tableData.secondaryText,
                isNumeric: true, maxDataLenght: 2,
                rangeAllowed: LimitValues(min: 2, max: 16)
            )
        
        case 2: // pontos
            let row = indexPath.row
            let point = self.pointData[row]
            
            guard !point.isDefault else { return }
            
            data = TextEditData(
                title: "Pontos", defaultData: tableData.primaryText,
                isNumeric: false, maxDataLenght: 15, isDeletable: true
            )
        
        default:
            return
        }
        
        guard let data else { return }
        self.cellEditedPosition = indexPath
        self.settingProtocol?.openTextEditPage(for: data)
    }
    
    
    /// Cria o pop up de aviso de componente inativo
    private func createInactiveWarning() -> UIAlertController {
        let alert = UIAlertController(
            title: "Aviso",
            message: "Essa funcionalidade ainda está sendo testada. Logo logo vai estar disponível!",
            preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        return alert
    }
}
