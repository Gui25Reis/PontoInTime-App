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
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.myView.reloadTableData()
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
    
    internal func saveDataEdited(with data: String) {
        
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
}
