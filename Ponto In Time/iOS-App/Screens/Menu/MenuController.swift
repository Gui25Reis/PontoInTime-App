/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


protocol UpdateSuperviewData: NSObject {
    
    func updateSuperviewData()
}


/// Controller responsável pela primeira tela da aplicação
class MenuController: UIViewController, UpdateSuperviewData {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = MenuView()
    
    
    /* Delegate & Data Sources */
    
    private let infoDataSource = InfoMenuDataSource()
    
    
    static var temporary = false
    
    
    
    /* MARK: - Construtor */
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    

		
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
    
    internal func updateSuperviewData() {
        if Self.temporary {
            self.myView.setViewData(for: "")
        }
    }
	

    
    /* MARK: - Ações de botões */
    
    @objc private func openSettingsPage() {
        let vc = SettingsController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func createNewWorkPage() {
        let vc = PointInfoController()
        vc.superviewProtocol = self
        
        let navBar = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navBar, animated: true)
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
        self.myView.setNewDayAction(target: self, action: #selector(self.createNewWorkPage))
    }
    
    
    /// Definindo os delegates, data sources e protocolos
    private func setupDelegates() {
        self.myView.infoTable.setDataSource(with: self.infoDataSource)
        self.myView.pointsTable.setDataSource(with: self.infoDataSource)
    }
    
    
    ///
    private func setupView() {
        //self.myView.setViewData(for: "")
    }
}
