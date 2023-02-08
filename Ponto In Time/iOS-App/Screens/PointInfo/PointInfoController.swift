/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit

enum PointInfoType {
    /// Ponto incial de trabalho
    case initial
    
    /// Ponto fincla de trabalho
    case final
    
    /// Adicionando um novo ponto
    case new
    
    /// Ver/atualizar um ponto qualquer
    case update
}

/// Controller responsável pela tela de informações de um ponto
class PointInfoController: UIViewController, ControllerActions, PointInfoProtocol, DocumentsHandlerDelegate {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = ViewWithTable()
    
    
    /* Delegate & Data Sources */
    
    /// Protocolo de comunicação com a tela de menu
    public weak var menuControllerProtocol: ViewWithDayWorkInfoDelegate?
    
    /// Handler da tabela de informações de um ponto
    private let pointInfoHanlder = PointInfoTableHandler()
    
    /// Handler dos pickers de documentos
    private let documentsHandler = DocumentsHandler()
    
    
    
    /* Outros */
    
    /// Tipo de ponto
    private var pointType: PointInfoType = .initial
    
    /// Hora do picker
    private var pickerHour: String = ""
    
    
    
    /* Infos Alterações */
    
    /// Arquivos que forma adicionados
    private var filesToAdd: [ManagedFiles] = []
    
    /// Arquivos que foram deletados
    private var filesToDelete: [ManagedFiles] = []
    
    /// Infos do ponto sem alteração
    private var originalPoint: ManagedPoint?
    
    
    
    /* MARK: - Construtor */
    
    init(type: PointInfoType, data: ManagedPoint? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.pointType = type
        self.originalPoint = data
        self.setupCell(for: data)
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.updateChangesOnCoreData()
    }
    
    
    
    /* MARK: - Protocolo */
    
    /* Controller Actions */
    
    internal func setupNavigation() {
        self.navigationItem.largeTitleDisplayMode = .never
        
        switch self.pointType {
        case .initial, .final, .new:
            self.setupNewPointNavigation()
        default:
            self.setupDefaultNavigation()
        }
    }
    
    
    internal func setupDelegates() {
        self.documentsHandler.delegate = self
        
        self.pointInfoHanlder.delegate = self
        self.pointInfoHanlder.link(with: self.myView)
    }
    
    
    internal func setupButtonsAction() {}
    
    
    
    /* Point Info Protocol */
    
    internal func updateMenuData(at index: Int, data: String) {
        guard var tableData = self.pointInfoHanlder.mainData else { return }
        
        if index == 0 {
            tableData.pointType = ManagedPointType(title: data)
        } else {
            tableData.status = data
        }
        
        self.setupTableData(with: tableData)
    }
    
    
    internal func updateTimeFromPicker(for time: String) {
        self.pickerHour = time
    }
    
    
    internal func openFilePickerSelection() {
        let menu = self.createPickersMenu()
        self.showAlert(menu)
    }
    
    
    internal func openShareMenu(_ menu: UIActivityViewController) {
        self.present(menu, animated: true)
    }
    
    
    internal func deleteFileAction(file: ManagedFiles, at row: Int) {
        let message = "Tem certeza que deseja exluir o arquivo? Talvez ele não esteja salvo no seu dispositivo."
        let alert = UIAlertController.createDeleteAlert(message: message) {
            self.deleteFile(file, at: row)
        }
        self.showAlert(alert)
    }
    
    
    
    /* DocumentsHandlerDelegate */
    
    internal func documentSelected(_ document: ManagedFiles?, image: UIImage?) {
        guard let document, var tableData = self.pointInfoHanlder.mainData else { return }
        
        self.filesToAdd.append(document)
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
        guard var data = self.pointInfoHanlder.mainData else { return self.dismissAction() }
        
        data.time = self.pickerHour
        
        switch pointType {
        case .initial:
            self.menuControllerProtocol?.setupInitalData(with: data)
        case .new:
            self.menuControllerProtocol?.addNewPoint(with: data)
        default:
            break
        }
        
        self.dismissAction()
    }
    
    
    /// Abre um dos tipos de seleção de arquivos
    /// - Parameter type: tipo de seleção de arquivo
    private func showPicker(for type: PickerType) {
        guard let picker = self.documentsHandler.createPicker(for: type) else { return }
        self.present(picker, animated: true)
    }
    
    
    /// Deleta um arquivo
    /// - Parameter file: arquivo que vai ser deletado
    private func deleteFile(_ file: ManagedFiles, at row: Int) {
        guard var tableData = self.pointInfoHanlder.mainData else { self.myView.reloadTableData(); return }
        let data = tableData.files.remove(at: row)
        
        var needsToDelete = true
        for index in 0..<self.filesToAdd.count {
            guard self.filesToAdd[index].name == file.name else { continue }
            
            self.filesToAdd.remove(at: index)
            needsToDelete = false
            break
        }
        if needsToDelete { self.filesToDelete.append(data) }
        
        self.setupTableData(with: tableData)
    }
    
    
    /// Ação do botão de deletar um ponto
    @objc private func deletePointAction() {
        let message = "Tem certeza que deseja deletar o ponto?"
        let alert = UIAlertController.createDeleteAlert(message: message) {
            self.menuControllerProtocol?.deletePointSelected()
            self.dismissAction()
        }
        self.showAlert(alert)
    }
    
    
    
    /* MARK: - Configurações */

    /// Mostra as informações do ponto
    private func setupCell(for data: ManagedPoint?) {
        guard let data else { self.createDefaultTableData(); return }
        self.setupTableData(with: data)
    }
    
    
    /// Cria os dados inicias para a tabela
    private func createDefaultTableData() {
        var initialData = ManagedPoint(
            status: "Entrada", time: "", files: [],
            pointType: ManagedPointType(title: "Trabalho", isDefault: true)
        )
        
        if self.pointType == .initial {
            initialData.pointType = ManagedPointType(title: "Nenhum")
        }
        self.setupTableData(with: initialData)
    }
    
    
    /// Configura os dados da tabela
    /// - Parameter data: dados
    private func setupTableData(with data: ManagedPoint) {
        self.pointInfoHanlder.isInitialData = self.pointType == .initial
        self.pointInfoHanlder.mainData = data
        self.myView.reloadTableData()
    }
    
    
    /// Configura a navigation bar quando for uma visualização de um ponto
    private func setupDefaultNavigation() {
        self.title = "Informações do ponto".localized()
        
        let rightBut = UIBarButtonItem(
            title: "Deletar", style: .plain,
            target: self, action: #selector(self.deletePointAction)
        )
        rightBut.tintColor = .systemRed
        
        self.navigationItem.rightBarButtonItem = rightBut
    }
    
    
    /// Configura a navigation bar quando for para adiconar um novo ponto
    private func setupNewPointNavigation() {
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
    
    

    /* MARK: - Criação (Alertas) */
    
    /// Cria o menu de opções para adiocnar um novo arquivo
    /// - Returns: menu de opções
    private func createPickersMenu() -> UIAlertController {
        let menu = UIAlertController(
            title: "Opções", message: "Escolha uma forma para selecionar o arquivo",
            preferredStyle: .actionSheet
        )
        
        let camera = self.createPickersMenuButton(title: "Tirar foto", type: .camera)
        let photos = self.createPickersMenuButton(title: "Escolher foto", type: .photos)
        let files = self.createPickersMenuButton(title: "Escolher documento", type: .files)
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        cancel.setValue(UIColor.systemRed, forKey: "titleTextColor")
        
        let actions = [camera, photos, files, cancel]
        menu.addActions(actions)
        
        return menu
    }
    
    
    /// Cria um botão de ação do picker de adioncar um arquivo
    /// - Parameters:
    ///   - title: título do botão
    ///   - type: tipo de ação
    /// - Returns: botão de ação
    private func createPickersMenuButton(title: String, type: PickerType) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { _ in self.showPicker(for: type) }
    }
    
    
    
    /* MARK: - Core Data */
    
    /// Atualiza os core data caso tenha tido alguma mudança
    private func updateChangesOnCoreData() {
        guard self.checkForInfosChanged() || self.checkForFilesDeleted() else { return }
        
        guard let newData = self.pointInfoHanlder.mainData else { return }
        self.menuControllerProtocol?.updatePointChanged(newPoint: newData)
    }
    
    
    /// Verifica se algum arquivo foi adicionado ou se alguma informação do ponto foi modificada
    /// - Returns: boleano que indica que tem alterações
    private func checkForInfosChanged() -> Bool {
        guard let old = self.originalPoint, let new = self.pointInfoHanlder.mainData
        else { return false }
                
        guard !(old == new) || !self.filesToAdd.isEmpty else { return false }
        
        let error = CDManager.shared.updatePoint(
            id: old.uuid, newData: new, filesToAdd: self.filesToAdd
        )
        self.showWarningPopUp(with: error)
        
        return true
    }
    
    
    /// Verifica se algum arquivo foi deletado
    /// - Returns: boleano que indica que tem alterações
    private func checkForFilesDeleted() -> Bool {
        guard !self.filesToDelete.isEmpty else { return false }
        
        let error = CDManager.shared.deleteFiles(self.filesToDelete)
        self.showWarningPopUp(with: error)
        
        return true
    }
}
