/* Gui Reis    -    gui.reis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIViewController


/// Controller responsável pela tela de ajustes
class SettingsController: UIViewController, ControllerActions, SettingsProtocol, TextEditProtocol {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = ViewWithTable()
    
    
    /* Delegate & Data Sources */
    
    /// Data source da tabela de ajustes
    private let settingsHandler = SettingsTableHandler()


		
    /* MARK: - Ciclo de Vida */
    
    override func loadView() {
        self.view = self.myView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupController()
        self.setupDataSourceData()
    }
    
        

    /* MARK: - Protocolos */
    
    // Settings protocol
    
    internal func copyAction(with text: String) {
        let copyWarning = CopyWarning()
        copyWarning.copyHandler(textToCopy: text)
    }
    
    
    internal func openTextEditPage(for data: TextEditData) {
        let vc = TextEditController(data: data, delegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // TextEditProtocol
    
    internal func dataEditHandler(data: DataEdited) {
        guard let section = self.settingsHandler.cellEditedPosition?.section else { return }
        self.settingsHandler.cellEditedPosition = nil
        
        var needToUpdate = false
        switch section {
        case 0:
            guard data.hasChanges else { break }
            needToUpdate = true
            
        case 2:
            needToUpdate = self.handlerPointsData(with: data)
            
        default:
            return
        }
        
        guard needToUpdate else { return }
        self.setupDataSourceData()
    }

    
    
    // Controller Actions
    
    internal func setupNavigation() {
        self.title = "Ajustes".localized()
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    
    internal func setupDelegates() {
        self.settingsHandler.settingProtocol = self
        self.settingsHandler.link(with: self.myView)
    }
    
    
    internal func setupButtonsAction() {}
    
    
    
    /* MARK: - Configurações */
    
    /// Definindo os delegates, data sources e protocolos
    private func setupDataSourceData() {
        let (data, _) = CDManager.shared.getSettingsData()
        
        guard let data else { return }
        self.updateTableData(for: data)
    }
    
    
    /// Atualiza os dados da tabela
    /// - Parameter data: dados atualizados
    private func updateTableData(for data: SettingsData) {
        self.settingsHandler.mainData = data
        self.myView.reloadTableData()
    }
    
    
    /// Lida com os dados dos pontos
    /// - Parameter data: dados
    /// - Returns: boleano que indica se deu tudo certo no final
    private func handlerPointsData(with data: DataEdited) -> Bool {
        if data.hasDeleted {
            guard let name = data.oldData else { return false }
            if let error = CDManager.shared.deletePointType(at: name) {
                self.showWarningPopUp(with: error)
                return false
            }
            return true
        }
        
        if data.isAdding {
            guard let name = data.newData else { return false }
            if let error = CDManager.shared.addNewPointType(name: name) {
                self.showWarningPopUp(with: error)
                return false
            }
            return true
        }
        
        if data.hasChanges {
            if let error = CDManager.shared.updatePointType(with: data) {
                self.showWarningPopUp(with: error)
                return false
            }
            return true
        }
        return false
    }
}
