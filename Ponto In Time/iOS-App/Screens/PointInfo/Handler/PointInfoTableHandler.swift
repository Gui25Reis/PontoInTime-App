/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Lida (handler) com a tabela de informações de um ponto
class PointInfoTableHandler: NSObject, TableHandler {
    
    /* MARK: - Atributos */
    
    // Protocolo de comunicação com a controller
    public weak var pointInfoProtocol: PointInfoProtocol?

    
    /// Dados usados no data source referente as informações do ponto
    private lazy var infoTitles: [String] = []
    
    /// Dados usados no data source referente aos arquivos
    private lazy var fileData: [TableData] = []
    
    
    
    /* MARK: - Protocolo */
    
    internal func getDataCount(for dataType: Int) -> Int {
        switch dataType {
        case 0: return self.infoTitles.count
        case 1: return self.fileData.count+1
        default: return 0
        }
    }
    
    
    func registerCell(in table: CustomTable) {
        table.registerCell(for: TableCell.self)
        table.registerCell(for: PointInfoCell.self)
    }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Boleano que diz se os dados são inicial
    public var isInitialData = true
    
    /// Dados base da tabela
    public var mainData: ManagedPoint? {
        didSet { self.setupDatas() }
    }
    
    /// Index da célula de adicionar
    public var actionIndex: Int {
        return self.fileData.count-1 + 1
    }
    
    
    
    /* MARK: - Data Source */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.defaultRowHeight
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getDataCount(for: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mainCell: UITableViewCell? = UITableViewCell()
        let row = indexPath.row
    
        switch indexPath.section {
        case 0: // Infos
            let title = self.infoTitles[row]
            
            var cellData = TableData(primaryText: title)
            
            switch row {
            case 0: // Título
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell
                cellData.secondaryText = self.mainData?.pointType.title ?? "Nenhum"
                
                if !self.isInitialData {
                    cellData.rightIcon = .contextMenu
                    
                    let menu = self.pointInfoProtocol?.createMenu(for: row)
                    cellData.menu = menu
                }
                
                cell?.tableData = cellData
                mainCell = cell
                
            case 1: // Status
                let cell = tableView.dequeueReusableCell(withIdentifier: PointInfoCell.identifier, for: indexPath) as? PointInfoCell
                cellData.secondaryText = ""
                
                if !self.isInitialData {
                    cellData.rightIcon = .contextMenu
                    
                    let menu = self.pointInfoProtocol?.createMenu(for: row)
                    cellData.menu = menu
                }
                
                cell?.tableData = cellData
                cell?.statusCell = StatusView.getCase(for: self.mainData?.status ?? "")
                mainCell = cell
                
            case 2: // Picker
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell
                cellData.hasPicker = true
                
                cell?.setTimerAction(target: self, action: #selector(self.hourPickerAction(sender:)))
                let time = cell?.datePicker.getDate(withFormat: .hm) ?? ""
                                     
                self.pointInfoProtocol?.updateTimeFromPicker(for: time)
                
                if let time = self.mainData?.time {
                    cell?.setTimerPicker(time: time)
                }
                
                cell?.tableData = cellData
                mainCell = cell
                
            default:
                break
            }

        
        case 1: // Arquivos
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell
            
            var data = TableData()
            if row == self.actionIndex {
                data.primaryText = "Adicionar arquivo"
                data.action = .action
            } else {
                data = self.fileData[row]
            }
            
            cell?.tableData = data
            mainCell = cell
            
        default:
            break
        }
        
        return mainCell ?? UITableViewCell()
    }
    
    
    
    /* MARK: - Delegate */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
        
        if indexPath.row == self.actionIndex {
            self.pointInfoProtocol?.openFilePickerSelection()
        }
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configura os dados
    private func setupDatas() {
        guard let data = self.mainData else { return }
        
        self.infoTitles = ["Título", "Estado", "Horário"]
        
        self.fileData = data.files.map {
            TableData(primaryText: $0.name, image: UIImage.loadFromDisk(imageName: $0.link))
        }
    }
    
    
    
    /* MARK: - Ações de botões */
    
    /// Ação do picker de horas
    @objc private func hourPickerAction(sender: UIDatePicker) {
        let time = sender.date.getDateFormatted(with: .hms)
        self.pointInfoProtocol?.updateTimeFromPicker(for: time)
    }
}
