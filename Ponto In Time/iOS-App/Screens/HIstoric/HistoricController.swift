/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Controller responsável POR
class HistoricController: UIViewController {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = HistoricView()
    
    
    /* Delegate & Data Sources */
    
    private let historicDataSource = HistoricDataSource()


		
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
    
    
    
    /* MARK: - Configurações */

    /// Configurções da navigation controller
    private func setupNavigation() {
    
    }

    
    /// Definindo as ações dos botões
    private func setupButtonsAction() {
	  
    }
    
    
    /// Definindo os delegates, data sources e protocolos
    private func setupDelegates() {
        self.myView.historicTable.setDataSource(with: self.historicDataSource)
    }
}
