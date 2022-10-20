/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Controller responsável pela tela de ajustes
class SettingsController: UIViewController {
    
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

        self.setupNavigation()
        self.setupDelegates()
    }


    
    /* MARK: - Configurações */

    /// Configurções da navigation controller
    private func setupNavigation() {
        self.title = "Ajustes".localized()
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    
    /// Definindo os delegates, data sources e protocolos
    private func setupDelegates() {
        self.myView.setDataSource(with: self.settingsDataSource)
    }
}
