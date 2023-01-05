/* Gui Reis    -    gui.reis25@gmail.com */

/* Bibliotecas necessárias: */

import class UIKit.UIViewController

import class Foundation.NSObject

protocol SettingsProtocol: NSObject {
    
    func copyAction(with text: String)
}


/// Controller responsável pela tela de ajustes
class SettingsController: UIViewController, ControllerActions, SettingsProtocol {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = SettingsView()
    
    
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
        CDManager.shared.getSettingsData() { result in
            switch result {
            case .success(let data):
                self.updateTableData(for: data)
            case .failure(let error):
                print(error.developerWarning)
            }
        }
    }
    
    
    /// Atualiza os dados da tabela
    /// - Parameter data: dados atualizados
    private func updateTableData(for data: SettingsData) {
        self.settingsHandler.mainData = data
        self.myView.reloadTableData()
    }
}
