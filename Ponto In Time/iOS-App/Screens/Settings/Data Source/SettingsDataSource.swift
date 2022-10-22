/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Data source das tables da página de ajustes
class SettingsDataSource: NSObject, TableDataCount {
        
    /* MARK: - Atributos */
        
    /// Dados usados no data source referente as informações das informações gerais
    private lazy var infoData: [CellData] = []
    
    
    /// Dados usados no data source referente as informações de compartilhamento
    private lazy var shareData: [CellData] = []
    
    private var isSharing: Bool = false
    
    
    /// Dados usados no data source referente aos tipos de pontos
    private lazy var pointData: [ManagedPointType] = []
    
        
    
    /* MARK: - Protocolo */
    
    weak var reloadDataProtocol: TableReloadData?
    
    
    func getDataCount(for dataType: Int) -> Int {
        switch dataType {
        case 0: return self.infoData.count
        case 1: return self.shareData.count
        case 2: return self.pointData.count+1
        default: return 0
        }
    }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Dados usados dos ajustes
    public var mainData: SettingsData? {
        didSet {
            self.setupDatas()
        }
    }
    
    
    
    /* MARK: - Data Source */
    
    /// Mostra quantas células vão ser mostradas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getDataCount(for: tableView.tag)
    }
    
    
    /// Configura uma célula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        
        switch tableView.tag {
        
        case 0: // infos gerais
            let data = self.infoData[indexPath.row]
            cell.setupCellData(with: data)
            
    
        case 1: // compartilhamento
            let data = self.shareData[indexPath.row]
            cell.setupCellData(with: data)
            
            if indexPath.row == 1 {
                cell.updateSwitchVisibility(for: true)
                cell.updateSwitchStatus(for: self.isSharing)
            }
    
            
        case 2: // pontos
            if indexPath.row < self.pointData.count {
                let data = self.pointData[indexPath.row]
                
                var cellData = CellData(primaryText: data.title)
                if !data.isDefault {
                    cellData.rightIcon = .chevron
                }
                cell.setupCellData(with: cellData)
                
                return cell
            }
            
            cell.setupCellAction(with: CellAction(
                actionType: .action, actionTitle: "Novo"
            ))
        
        default: break
        }
        return cell
    }
    
    
    
    /* MARK: - Configurações */
    
    private func setupDatas() {
        if let settings = self.mainData?.settingsData {
            self.infoData = [
                CellData(primaryText: "Horas de trabalho", secondaryText: settings.timeWork)
            ]
            
            self.shareData = [
                CellData(primaryText: "Seu ID", secondaryText: settings.sharingID),
                CellData(primaryText: "Compartilhar saída")
            ]
            self.isSharing = settings.isSharing
        }
        
        self.pointData = self.mainData?.pointTypeData ?? []
    }
}
