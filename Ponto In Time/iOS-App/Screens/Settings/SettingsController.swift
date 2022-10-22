/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Controller responsável pela tela de ajustes
class SettingsController: UIViewController, TableReloadData {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = SettingsView()
    
    
    /* Delegate & Data Sources */
    
    /// Data source da tabela de ajustes
    private let settingsDataSource = SettingsDataSource()


		
    /* MARK: - Ciclo de Vida */
    
    override func loadView() {
        self.view = self.myView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupDelegates()
        self.setupNavigation()
        self.setupDataSourceData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.myView.reloadTableData()
    }
    
    
    
    /* MARK: - Protocolo */
    
    internal func reloadTableData() {
        self.myView.reloadTableData()
        self.myView.reloadInputViews()
    }
    
    

    /* MARK: - Configurações */

    /// Configurções da navigation controller
    private func setupNavigation() {
        self.title = "Ajustes".localized()
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    
    /// Definindo os delegates, data sources e protocolos
    private func setupDelegates() {
        self.settingsDataSource.reloadDataProtocol = self
        self.myView.setDataSource(with: self.settingsDataSource)
    }
    
    
    /// Definindo os delegates, data sources e protocolos
    private func setupDataSourceData() {
        CDManager.shared.getSettingsData() { result in
            switch result {
            case .success(let data):
                self.updateTableData(for: data)
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    
    private func updateTableData(for data: SettingsData) {
        self.settingsDataSource.mainData = data
        self.myView.reloadTableData()
    }
}



