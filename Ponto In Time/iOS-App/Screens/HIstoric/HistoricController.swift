/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIViewController


/// Controller responsável pela tela de histórico
class HistoricController: UIViewController, ControllerActions {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = ViewWithTable()
    
    
    /* Delegate & Data Sources */
    
    /// Data source da tabela de histórico
    private let historicHandler = HistoricTableHandler()


		
    /* MARK: - Ciclo de Vida */
    
    override func loadView() {
        self.view = self.myView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupController()
        self.setupTableData(with: nil)
    }

    
    
    /* MARK: - Protocolos */

    internal func setupDelegates() {
        self.historicHandler.link(with: self.myView)
    }
    
    
    internal func setupButtonsAction() {}
    
    internal func setupNavigation() {}
    
    
    
    /* MARK: - Configurações */
    
    /// Define os dados da tabela
    /// - Parameter data: dados que a tabela vai receber
    private func setupTableData(with data: ManagedDayWork?) {
        self.historicHandler.mainData = data
        self.myView.reloadTableData()
    }
}
