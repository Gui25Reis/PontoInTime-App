/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Data source das tabelas de informações de um ponto
class PointInfoDataSource: NSObject, TableDataCount {
    var reloadDataProtocol: TableReloadData?
    
    var pointInfoProtocol: PointInfoProtocol?
    
    /* MARK: - Atributos */

    /// Dados usados no data source referente as informações do ponto
    public lazy var infoTitles: [String] = []
    
    
    /// Dados usados no data source referente aos arquivos
    public lazy var fileData: [CellData] = [
        CellData(primaryText: "Anexo_16102022-9_41"),
    ]
    
    
    public var isInitialData = true
    
    public var mainData: ManagedPoint? {
        didSet {
            self.setupDatas()
        }
    }
    
        
    
    /* MARK: - Protocolo */
    
    func getDataCount(for dataType: Int) -> Int {
        switch dataType {
        case 0: return self.infoTitles.count
        case 1: return self.fileData.count+1
        default: return 0
        }
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
        
        switch tableView.tag {
            
        case 0:
            let title = self.infoTitles[row]
            
            var cellData = CellData(primaryText: title)
            
            switch row {
            case 0:
                cellData.secondaryText = self.mainData?.pointType.title ?? "Nenhum"
                cell.setupCellData(with: cellData)
                
                if !self.isInitialData {
                    cellData.rightIcon = .contextMenu
                    cell.setupCellData(with: cellData)
                    
                    self.pointInfoProtocol?.createMenu(for: row, with: cell)
                }
                
                return cell
                
            case 1:
                cell.setupCellData(with: cellData)
                let time = cell.setTimerAction(
                    target: self, action: #selector(self.hourPickerAction(sender:))
                )
                self.pointInfoProtocol?.updateTimeFromPicker(for: time)
                
                if !self.isInitialData {
                    cellData.rightIcon = .contextMenu
                    cell.setupCellData(with: cellData)
                    
                    self.pointInfoProtocol?.createMenu(for: row, with: cell)
                }
                cell.statusCell = StatusView.getCase(for: self.mainData?.status ?? "")
                
                return cell
                
            case 2:
                cell.setupCellData(with: cellData)
                
                cell.isTimePicker = true
                if let time = self.mainData?.time {
                    cell.setTimerPicker(time: time)
                }
                
                return cell
                
            default:
                break
            }

        
        case 1:
            if row < self.fileData.count {
                let data = self.fileData[row]
                cell.setupCellData(with: data)
                return cell
            }
            
            cell.setupCellAction(with: CellAction(
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
                CellData(primaryText: item.name, image: UIImage(named: item.link))
            }
        }
    }
    
    
    @objc private func hourPickerAction(sender: UIDatePicker) {
        let time = sender.date.getDateFormatted(with: .hm)
        self.pointInfoProtocol?.updateTimeFromPicker(for: time)
    }
}
