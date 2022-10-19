/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Controller responsável pela primeira tela da aplicação
class MenuController: UIViewController {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = MenuView()
    
    
    /* Delegate & Data Sources */
    
    private let infoDataSource = InfoMenuDataSource()


		
    /* MARK: - Ciclo de Vida */
    
    override func loadView() {
        self.view = self.myView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.setupDelegates()
        self.setupButtonsAction()
    }
    


    /* MARK: - Protocolo */

	

    /* MARK: - Ações de botões */
    
    
    @objc private func openSettingsPage() {
        
    }
    
    
    
    /* MARK: - Configurações */

    /// Configurções da navigation controller
    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(.settings), style: .plain,
            target: self, action: #selector(self.openSettingsPage)
        )
    }

    
    /// Definindo as ações dos botões
    private func setupButtonsAction() {
	  
    }
    
    
    /// Definindo os delegates, data sources e protocolos
    private func setupDelegates() {
        self.myView.infoTable.setDataSource(with: self.infoDataSource)
        self.myView.pointsTable.setDataSource(with: self.infoDataSource)
    }
}
