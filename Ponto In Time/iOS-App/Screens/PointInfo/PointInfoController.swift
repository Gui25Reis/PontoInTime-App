/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Controller responsável pela tela de informações de um ponto
class PointInfoController: UIViewController {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = PointInfoView()
    
    
    /* Delegate & Data Sources */
    
    /// Data source das tabelas das informações de um ponto
    private let pointInfoDataSource = PointInfoDataSource()

		
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

    /// Configurações da navigation controller
    private func setupNavigation() {
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    
    /// Definindo os delegates, data sources e protocolos
    private func setupDelegates() {
        self.myView.setDataSource(with: self.pointInfoDataSource)
    }
}
