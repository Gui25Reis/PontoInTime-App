/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Lida (handler) com a tabela de informações de um ponto
class PointInfoTableHandler: NSObject, TableHandler {
    
    /* MARK: - Atributos */
    
    /// Protocolo de comunicação com a controller
    public weak var delegate: PointInfoProtocol?

    
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
    
    
    internal func registerCell(in table: CustomTable) {
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
    public var actionIndex: Int { return self.fileData.count }
    
    
    
    /* MARK: - Data Source */
    
    // Tamanho das células
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.defaultRowHeight
    }
    
    
    // Quantidade de sessões que a tabela vai ter
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    // Quantidade de linhas que a tabela vai ter
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getDataCount(for: section)
    }
    
    
    // Configura os dados da célula
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
                    cellData.menu = self.createPointsTypeMenu()
                }
                
                cell?.tableData = cellData
                mainCell = cell
                
            case 1: // Status
                let cell = tableView.dequeueReusableCell(withIdentifier: PointInfoCell.identifier, for: indexPath) as? PointInfoCell
                cellData.secondaryText = ""
                
                if !self.isInitialData {
                    cellData.rightIcon = .contextMenu
                    cellData.menu = self.createStatusViewMenu()
                }
                
                cell?.tableData = cellData
                cell?.statusCell = StatusView.getCase(for: self.mainData?.status ?? "")
                mainCell = cell
                
            case 2: // Picker
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell
                cellData.hasPicker = true
                
                cell?.setTimerAction(target: self, action: #selector(self.hourPickerAction(sender:)))
                let time = cell?.datePicker.getDate(withFormat: .hm) ?? ""
                                     
                self.delegate?.updateTimeFromPicker(for: time)
                
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
                data.menu = self.createFileMenu(for: indexPath)
            }
            
            cell?.tableData = data
            mainCell = cell
            
        default:
            break
        }
        
        return mainCell ?? UITableViewCell()
    }
    
    
    
    /* MARK: - Delegate */
    
    // Define o que acontece quando clica na célula
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
        
        switch indexPath.section {
        case 1:
            guard indexPath.row == self.actionIndex else { break }
            self.delegate?.openFilePickerSelection()
        
        default:
            break
        }
    }
    
    
    // Define se é possível configurar uma ação na célula (swipe)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 && indexPath.row != self.actionIndex
    }
    
    
    // Define a ação de swipe na célula (lado direito)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard self.tableView(tableView, canEditRowAt: indexPath) else { return nil }
        
        let delete = UIContextualAction(style: .destructive, title: "Remover") { _, _, handler in
            let row = indexPath.row
            guard let file = self.mainData?.files[row] else { return handler(false) }
            
            self.delegate?.deleteFileAction(file: file, at: row)
            handler(self.delegate != nil)
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
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
        self.delegate?.updateTimeFromPicker(for: time)
    }
    
    
    /// Ação de salvar uma imagem no álbum de fotos
    /// - Parameter image: imagem que vai ser salva
    private func saveToPhotos(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    
    /// Ação de compartilhar uma imagem
    /// - Parameter image: imagem que vai ser compartilhada
    private func shareImage(_ image: UIImage) {
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        self.delegate?.openShareMenu(vc)
    }
    
    
    /// Ação de copiar uma imagem
    /// - Parameter image: imagem que vai ser copiada
    private func copyImage(_ image: UIImage) {
        UIPasteboard.general.image = image
    }
    
    
    
    /* MARK: - Criação (Context Menu) */
    
    /// Cria o context menu para a célula de mostrar os pontos disponiveis
    /// - Returns: constext menu
    private func createPointsTypeMenu() -> UIMenu {
        let pointsType = CDManager.shared.getAllPointType() ?? []

        let actions = pointsType.map() {
            let title = $0.title
            let action = UIAction(title: title) {_ in
                self.delegate?.updateMenuData(at: 0, data: title)
            }
            return action
        }
        
        let menu = UIMenu(title: "Pontos", children: actions)
        return menu
    }
    
    
    /// Cria o context menu para a célula de mostrar os estados disponiveis
    /// - Returns: constext menu
    private func createStatusViewMenu() -> UIMenu {
        let actions = StatusViewStyle.allCases.map() {
            let title = $0.word
            let image = StatusView.getImage(for: $0)
            let action = UIAction(title: title, image: image) {_ in
                self.delegate?.updateMenuData(at: 1, data: title)
            }
            return action
        }
        
        let menu = UIMenu(title: "Tipos", children: actions)
        return menu
    }
    
    
    /// Cria o context menu de opções para lidar com um arquivo
    /// - Parameter indexPath: posição da célua (arquivo)
    /// - Returns: context menu
    private func createFileMenu(for indexPath: IndexPath) -> UIMenu? {
        let row = indexPath.row
        guard
            let file = self.mainData?.files[row], let image = self.fileData[row].leftIcon
        else { return nil }
        
        var actions: [UIAction] = []
        
        actions.append(UIAction(title: "Salvar em fotos", image: UIImage(.saveToPhotos)) {_ in
            self.saveToPhotos(image: image)
        })
                
        actions.append(UIAction(title: "Copiar", image: UIImage(.copy)) {_ in
            self.copyImage(image)
        })
        
        actions.append(UIAction(title: "Compartilher", image: UIImage(.share)) {_ in
            self.shareImage(image)
        })
        
        
        let delete = UIAction(title: "Deletar", image: UIImage(.delete), attributes: .destructive) {_ in
            self.delegate?.deleteFileAction(file: file, at: row)
        }
        delete.image?.withTintColor(.systemRed)
        actions.append(delete)
        
        let menu = UIMenu(title: "", children: actions)
        return menu
    }
}
