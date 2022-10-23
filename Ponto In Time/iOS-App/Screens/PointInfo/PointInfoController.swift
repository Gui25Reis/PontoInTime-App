/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Controller responsável pela tela de informações de um ponto
class PointInfoController: UIViewController, PointInfoProtocol {

    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = PointInfoView()
    
    
    /* Delegate & Data Sources */
    
    /// Protocolo de comunicação com a tela de menu
    public var menuControllerProtocol: MenuControllerProtocol?
    
    
    /// Data source das tabelas das informações de um ponto
    private let pointInfoDataSource = PointInfoDataSource()
    
    /// Delegate das tabelas das informações de um ponto
    private let pointInfoDelegate = PointInfoDelegate()
    
    
    /* Outros */
    
    /// Se o dado apresentado é o primeiro ponto do dia
    private var isFirstPoint = true
    
    /// Se o dado apresentado é um novo dado
    private var isNewPoint = false
    
    /// Hora do picker
    private var pickerHour: String = ""
    
    
    
    /* MARK: - Construtor */
    
    init(with data: ManagedPoint? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.setupCell(for: data)
    }
    
    init(isNewData: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.isNewPoint = isNewData
        self.setupCell(for: nil)
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
    
    internal func createMenu(for cell: PointInfoCell) {
        switch cell.tag {
        case 0:
            self.createPointsTypeMenu(for: cell)
            
        case 1:
            self.createStatusViewMenu(for: cell)
            
        default:
            break
        }
    }
    
    
    internal func updateTimeFromPicker(for time: String) {
        self.pickerHour = time
    }
    
    
    internal func cellSelected(at indexPath: IndexPath) {
        
    }
    
    
    
    /* MARK: - Ações de Botões */
    
    /// Ação do botão de fechar a janela: fecha sem salvar
    @objc private func dismissAction() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    
    /// Ação do botão de salvar: salva os dados e fecha a janela
    @objc private func saveAction() {
        if let data = self.pointInfoDataSource.mainData {
            var updateData = data
            updateData.time = self.pickerHour
            
            if self.isFirstPoint {
                self.menuControllerProtocol?.setupInitalData(with: updateData)
            } else

            if self.isNewPoint {
                self.menuControllerProtocol?.addNewPoint(with: updateData)
            }
        }
        self.dismissAction()
    }
    
    
    /// Ação do context menu: atualiza o dado selecionado
    /// - Parameters:
    ///   - index: index da opção
    ///   - newData: novo dado
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
    
    
    
    /* MARK: - Configurações */

    /// Configurações da navigation controller
    private func setupNavigation() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = "Informações do ponto".localized()
        
        if self.isFirstPoint || self.isNewPoint {
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
            self.isFirstPoint = false
            self.setupTableData(with: data)
            return
        }
        
        var initialData = ManagedPoint(
            status: "Entrada",
            time: "",
            files: [],
            pointType: ManagedPointType(title: "Trabalho", isDefault: true)
        )
        
        if self.isNewPoint {
            self.isFirstPoint = false
            initialData.pointType = ManagedPointType(title: "Nenhum", isDefault: false)
        }
        
        self.setupTableData(with: initialData)
    }
    
    
    /// Configura os dados da tabela
    /// - Parameter data: dados
    private func setupTableData(with data: ManagedPoint) {
        self.pointInfoDataSource.isInitialData = self.isFirstPoint
        self.pointInfoDataSource.mainData = data
        self.myView.reloadTableData()
    }
    
    
    
    /* Context Menu */
    
    /// Cria o context menu para a célula de mostrar os pontos disponiveis
    /// - Parameter cell: célula que vai ser atribuida o menu
    private func createPointsTypeMenu(for cell: PointInfoCell) {
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
                        self.updateData(at: 0, newData: item.title)
                    }
                    actions.append(action)
                }

                let menu = UIMenu(title: "Pontos", children: actions)
                cell.setMenuCell(for: menu)
            }
        }
    }
    
    
    /// Cria o context menu para a célula de mostrar os estados disponiveis
    /// - Parameter cell: célula que vai ser atribuida o menu
    private func createStatusViewMenu(for cell: PointInfoCell) {
        var actions: [UIAction] = []
        for item in StatusViewStyle.allCases {
            let action = UIAction(
                title: item.word,
                image: StatusView.getImage(for: item)
            ) {_ in
                self.updateData(at: 1, newData: item.word)
            }
            
            actions.append(action)
        }
        
        let menu = UIMenu(title: "Tipos", children: actions)
        cell.setMenuCell(for: menu)
    }
}
