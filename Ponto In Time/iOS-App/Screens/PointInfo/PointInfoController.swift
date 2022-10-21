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
    
    
    /// View principal que a classe vai controlar
    private var isNewPoint = true
    
    
    /* MARK: - Construtor */
    
    init(with data: ManagedPoint? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        if let data {
            self.isNewPoint = false
        }
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public var superviewProtocol: UpdateSuperviewData?
    
    
    /* MARK: - Açòes de Botões */
    
    @objc private func dismissAction() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    
    @objc private func saveAction() {
        MenuController.temporary = true
        self.superviewProtocol?.updateSuperviewData()
        self.dismissAction()
    }
    
    
    /* MARK: - Configurações */

    /// Configurações da navigation controller
    private func setupNavigation() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = "Informações do ponto".localized()
        
        if self.isNewPoint {
            self.title = "Novo ponto".localized()
            
            let leftBut = UIBarButtonItem(
                title: "Cancelar", style: .plain,
                target: self, action: #selector(self.dismissAction)
            )
            leftBut.tintColor = .systemRed
            
            self.navigationItem.leftBarButtonItem = leftBut
            
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Salvar", style: .plain,
                target: self, action: #selector(self.saveAction)
            )
        }
    }
    
    
    /// Definindo os delegates, data sources e protocolos
    private func setupDelegates() {
        self.myView.setDataSource(with: self.pointInfoDataSource)
    }
}
