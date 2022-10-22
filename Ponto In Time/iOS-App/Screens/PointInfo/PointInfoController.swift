/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


protocol PointInfoProtocol {
    
    func createMenu(for index: Int, with cell: PointInfoCell)
}

/// Controller responsável pela tela de informações de um ponto
class PointInfoController: UIViewController, PointInfoProtocol {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = PointInfoView()
    
    
    /* Delegate & Data Sources */
    
    /// Data source das tabelas das informações de um ponto
    private let pointInfoDataSource = PointInfoDataSource()
    
    
    private let pointInfoDelegate = PointInfoDelegate()
    
    
    /// View principal que a classe vai controlar
    private var isNewPoint = true
    
    
    /* MARK: - Construtor */
    
    init(with data: ManagedPoint? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        let data1 = ManagedPoint(
            status: "Saída",
            time: "11:45",
            files: [],
            pointType: ManagedPointType(title: "Almoço", isDefault: true)
        )
        self.setupCell(for: data1)
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
    
    
    
    /* MARK: - Protocolo */
    
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
        self.pointInfoDataSource.pointInfoProtocol = self

        self.myView.setDataSource(with: self.pointInfoDataSource)
        self.myView.setDelegate(with: self.pointInfoDelegate)
    }
    
    
    /// Mostra as informações do ponto
    private func setupCell(for data: ManagedPoint?) {
        if let data {
            self.isNewPoint = false
            self.setupTableData(with: data)
            return
        }
        
        let initialData = ManagedPoint(
            status: "Entrada",
            time: "",
            files: [],
            pointType: ManagedPointType(title: "Trabalho", isDefault: true)
        )
        self.setupTableData(with: initialData)
    }
    
    
    /// Configura os dados da tabela
    /// - Parameter data: dados
    private func setupTableData(with data: ManagedPoint) {
        self.pointInfoDataSource.isInitialData = self.isNewPoint
        self.pointInfoDataSource.mainData = data
        self.myView.reloadTableData()
    }
    
    
    private func updateData(at index: Int, newData: String) {
        if let dataSourceData = self.pointInfoDataSource.mainData {
            var data = dataSourceData
            
            if index == 0 {
                data.pointType = ManagedPointType(title: newData, isDefault: false)
            } else {
                data.status = newData
            }
            
            self.setupTableData(with: data)
        }
    }
    
    
    internal func createMenu(for index: Int, with cell: PointInfoCell) {
        switch index {
        case 0:
            let group = DispatchGroup()
            var pointsType = CDManager.shared.getAllPointType() { _ in }

            if pointsType == nil {
                group.enter()
                _ = CDManager.shared.getAllPointType() { result in
                    defer {group.leave()}
                    
                    switch result {
                    case .success(let data):
                        pointsType = data
                    case .failure(let error):
                        print(error.description)
                    }
                }
            }

            group.notify(queue: .main) {
                if let pointsType {
                    var actions: [UIAction] = []

                    for item in pointsType {
                        let action = UIAction(title: item.title) {_ in
                            print("Título selecionado: ", item.title)
                            self.updateData(at: index, newData: item.title)
                        }
                        actions.append(action)
                    }

                    let menu = UIMenu(title: "Pontos", children: actions)
                    cell.setMenuCell(for: menu)
                }
            }
            
        
        case 1:
            var actions: [UIAction] = []
            for item in StatusViewStyle.allCases {
                let action = UIAction(
                    title: item.word,
                    image: StatusView.getImage(for: item)
                ) {_ in
                    print("Status selecionado: ", item.word)
                    self.updateData(at: index, newData: item.word)
                }
                
                actions.append(action)
            }
            
            let menu = UIMenu(title: "Tipos", children: actions)
            cell.setMenuCell(for: menu)
            
        default:
            break
        }
    }
}
