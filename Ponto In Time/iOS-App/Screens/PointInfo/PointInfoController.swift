/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Controller responsável pela tela de informações de um ponto
class PointInfoController: UIViewController, ControllerActions, PointInfoProtocol, DocumentsHandlerDelegate {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = ViewWithTable()
    
    
    /* Delegate & Data Sources */
    
    /// Protocolo de comunicação com a tela de menu
    public weak var menuControllerProtocol: MenuControllerProtocol?
    
    /// Handler da tabela de informações de um ponto
    private let pointInfoHanlder = PointInfoTableHandler()
    
    /// Handler dos pickers de documentos
    private let documentsHandler = DocumentsHandler()
    
    
    
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

        self.setupController()
    }
    
    
    
    /* MARK: - Protocolo */
    
    /* Controller Actions */
    
    internal func setupNavigation() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = "Informações do ponto".localized()
        
        guard self.isFirstPoint || self.isNewPoint else { return }
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
    
    
    internal func setupDelegates() {
        self.documentsHandler.delegate = self
        
        self.pointInfoHanlder.pointInfoProtocol = self
        self.pointInfoHanlder.link(with: self.myView)
    }
    
    
    internal func setupButtonsAction() {}
    
    
    /* Point Info Protocol */
    
    internal func createMenu(for row: Int) -> UIMenu? {
        switch row {
        case 0:
            return self.createPointsTypeMenu()
        case 1:
            return self.createStatusViewMenu()
        default:
            return nil
        }
    }
    
    
    internal func updateTimeFromPicker(for time: String) {
        self.pickerHour = time
    }
    
    
    internal func openFilePickerSelection() {
        let menu = self.createPickersMenu()
        self.showAlert(menu)
    }
    
    
    /* DocumentsHandlerDelegate */
    
    internal func documentSelected(_ document: ManagedFiles?, image: UIImage?) {
        guard
            let document, var tableData = self.pointInfoHanlder.mainData
        else {
            print("Não deu certo")
            return
        }
        
        tableData.files.append(document)
        self.setupTableData(with: tableData)
    }
    
    
    /* MARK: - Ações de Botões */
    
    /// Ação do botão de fechar a janela: fecha sem salvar
    @objc private func dismissAction() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    
    /// Ação do botão de salvar: salva os dados e fecha a janela
    @objc private func saveAction() {
        if let data = self.pointInfoHanlder.mainData {
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
        guard var data = self.pointInfoHanlder.mainData else { return }
        
        if index == 0 {
            data.pointType = ManagedPointType(title: newData)
        } else {
            data.status = newData
        }
        
        self.setupTableData(with: data)
    }
    
    
    
    /* MARK: - Configurações */

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
        self.pointInfoHanlder.isInitialData = self.isFirstPoint
        self.pointInfoHanlder.mainData = data
        self.myView.reloadTableData()
    }
    
    
    /* Context Menu */
    
    /// Cria o context menu para a célula de mostrar os pontos disponiveis
    /// - Parameter cell: célula que vai ser atribuida o menu
    private func createPointsTypeMenu() -> UIMenu {
        let pointsType = CDManager.shared.getAllPointType() ?? []

        var actions: [UIAction] = []
        for item in pointsType {
            let action = UIAction(title: item.title) {_ in
                self.updateData(at: 0, newData: item.title)
            }
            actions.append(action)
        }

        let menu = UIMenu(title: "Pontos", children: actions)
        return menu
    }
    
    
    /// Cria o context menu para a célula de mostrar os estados disponiveis
    /// - Parameter cell: célula que vai ser atribuida o menu
    private func createStatusViewMenu() -> UIMenu {
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
        return menu
    }
    
    
    
    private func createPickersMenu() -> UIAlertController {
        let menu = UIAlertController(
            title: "Opções", message: "Escolha uma forma para selecionar o arquivo",
            preferredStyle: .actionSheet
        )
        
        
        // Botões
        
        let camera = UIAlertAction(title: "Tirar foto", style: .default) { _ in
            self.showPicker(for: .camera)
        }
        menu.addAction(camera)
        
        let album = UIAlertAction(title: "Escolher foto", style: .default) { _ in
            self.showPicker(for: .photos)
        }
        menu.addAction(album)
        
        let file = UIAlertAction(title: "Escolher documento", style: .default) { _ in
            self.showPicker(for: .files)
        }
        menu.addAction(file)
        
        
        let cancel = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        menu.addAction(cancel)
        
        return menu
    }
    
    
    private func showPicker(for type: PickerType) {
        guard let picker = self.documentsHandler.createPicker(for: type) else { return }
        self.present(picker, animated: true)
    }
}
