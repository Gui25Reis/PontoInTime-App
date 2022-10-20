/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Controller responsável pela tela de histórico
class HistoricController: UIViewController {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = HistoricView()
    
    
    /* Delegate & Data Sources */
    
    /// Data source da tabela de histórico
    private let historicDataSource = HistoricDataSource()


		
    /* MARK: - Ciclo de Vida */
    
    override func loadView() {
        self.view = self.myView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupDelegates()
    }

    
    
    /* MARK: - Configurações */

    /// Definindo os delegates, data sources e protocolos
    private func setupDelegates() {
        self.myView.historicTable.setDataSource(with: self.historicDataSource)
    }
}
