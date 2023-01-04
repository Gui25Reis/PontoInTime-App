/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Data source das tabelas de informações de um ponto
class PointInfoDataSource: NSObject {

    /* MARK: - Atributos */
    
    // Protocolo de comunicação com a controller
    public var pointInfoProtocol: PointInfoProtocol?

    
    /// Dados usados no data source referente as informações do ponto
    private lazy var infoTitles: [String] = []
    
    /// Dados usados no data source referente aos arquivos
    private lazy var fileData: [TableCellData] = [
        TableCellData(primaryText: "Anexo_16102022-9_41"),
    ]
    
        
    
    /* MARK: - Protocolo */
    
    internal func getDataCount(for dataType: Int) -> Int {
        switch dataType {
        case 0: return self.infoTitles.count
        case 1: return self.fileData.count+1
        default: return 0
        }
    }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Diz se os dados são inicial
    public var isInitialData = true
    
    /// Dados base da tabela
    public var mainData: ManagedPoint? {
        didSet {
            self.setupDatas()
        }
    }
    
    /// Index da célula de adicionar
    public var actionIndex: Int {
        return self.fileData.count-1 + 1
    }
    
    
    
    /* MARK: - Data Source */
    
    /// Mostra quantas células vão ser mostradas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getDataCount(for: tableView.tag)
    }
    
    
    /// Configura uma célula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointInfoCell.identifier, for: indexPath) as? PointInfoCell else {
            return UITableViewCell()
        }
        
        let row = indexPath.row
        cell.tag = row
    
        switch tableView.tag {
        case 0: // Infos
            let title = self.infoTitles[row]
            
            var cellData = TableCellData(primaryText: title)
            
            switch row {
            case 0: // Título
                cellData.secondaryText = self.mainData?.pointType.title ?? "Nenhum"
                cell.setupCellData(with: cellData)
                
                if !self.isInitialData {
                    cellData.rightIcon = .contextMenu
                    cell.setupCellData(with: cellData)
                    
                    self.pointInfoProtocol?.createMenu(for: cell)
                }
                
                return cell
                
            case 1: // Status
                cell.setupCellData(with: cellData)
                
                if !self.isInitialData {
                    cellData.rightIcon = .contextMenu
                    cell.setupCellData(with: cellData)
                    
                    self.pointInfoProtocol?.createMenu(for: cell)
                }
                cell.statusCell = StatusView.getCase(for: self.mainData?.status ?? "")
                
                return cell
                
            case 2: // Picker
                cell.setupCellData(with: cellData)
                
                let time = cell.setTimerAction(
                    target: self, action: #selector(self.hourPickerAction(sender:))
                )
                self.pointInfoProtocol?.updateTimeFromPicker(for: time)
                
                cell.isTimePicker = true
                if let time = self.mainData?.time {
                    cell.setTimerPicker(time: time)
                }
                
                return cell
                
            default:
                break
            }

        
        case 1: // Arquivos
            if row < self.fileData.count {
                let data = self.fileData[row]
                cell.setupCellData(with: data)
                return cell
            }
            
            cell.setupCellAction(with: TableCellAction(
                actionType: .action, actionTitle: "Adicionar arquivo"
            ))
        
        default:
            break
        }
                
        return cell
    }
    
    
    
    
    
    private func setupDatas() {
        if let mainData {
            self.infoTitles = ["Título", "Estado", "Horário"]
            
            self.fileData = mainData.files.map { item in
                TableCellData(primaryText: item.name, image: UIImage(named: item.link))
            }
        }
    }
    
    
    @objc private func hourPickerAction(sender: UIDatePicker) {
        let time = sender.date.getDateFormatted(with: .hms)
        self.pointInfoProtocol?.updateTimeFromPicker(for: time)
    }
}
