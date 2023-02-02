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
    
    
    
    /* Infos Alterações */
    
    /// Index dos arquivos que precisam ser salvos no Core Data
    private var filesToSave: [ManagedFiles] = [] {
        didSet {
            print("\nAdicionados: \(filesToSave)")
            print("Deletados: \(filesDeleted)")
        }
    }
    
    /// Arquivos que foram deletados
    private var filesDeleted: [ManagedFiles] = [] {
        didSet {
            print("\nAdicionados: \(filesToSave)")
            print("Deletados: \(filesDeleted)")
        }
    }
    
    /// Ponto sem alteração
    private var originalPoint: ManagedPoint?

        
    
    /* MARK: - Construtor */
    
    init(with data: ManagedPoint? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.originalPoint = data
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
        let alert = self.createDeleteAlert() {
            self.deleteAction(file: file, at: row)
        }
        self.showAlert(alert)
    }
    
    
    
    /* DocumentsHandlerDelegate */
    
    internal func documentSelected(_ document: ManagedFiles?, image: UIImage?) {
        guard let document, var tableData = self.pointInfoHanlder.mainData
        else { print("Não deu certo"); return }
        
        self.filesToSave.append(document)
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
        
        if self.isFirstPoint {
            self.menuControllerProtocol?.setupInitalData(with: data)
        } else

        if self.isNewPoint {
            self.menuControllerProtocol?.addNewPoint(with: data)
        }
        
        self.dismissAction()
    }
    
    
    /// Abre um dos tipos de seleção de arquivos
    /// - Parameter type: tipo de seleção de arquivo
    private func showPicker(for type: PickerType) {
        let picker = self.documentsHandler.createPicker(for: type)
        guard let picker else { return }
        self.present(picker, animated: true)
    }
    
    
    /// Deleta um arquivo
    /// - Parameter file: arquivo que vai ser deletado
    private func deleteAction(file: ManagedFiles, at row: Int) {
        guard var tableData = self.pointInfoHanlder.mainData else { return self.myView.reloadTableData() }
        
        let data = tableData.files.remove(at: row)
        
        var needsToDelete = true
        for index in 0..<self.filesToSave.count {
            guard self.filesToSave[index].name == file.name else { continue }
            
            self.filesToSave.remove(at: index)
            needsToDelete = false
            break
        }
        
        if needsToDelete { self.filesDeleted.append(data) }
        
        self.setupTableData(with: tableData)
    }
    
    
    private func updateChangesOnCoreData() {
        let files = Array(self.filesDeleted)
        
        let delete = CDManager.shared.deleteFiles(files)
        self.showWarningPopUp(with: delete)
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
            status: "Entrada", time: "", files: [],
            pointType: ManagedPointType(title: "Trabalho", isDefault: true)
        )
        
        if self.isNewPoint {
            self.isFirstPoint = false
            initialData.pointType = ManagedPointType(title: "Nenhum")
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
        return UIAlertAction(title: title, style: .default) { _ in self.showPicker(for: type)}
    }
    
    
    /// Cria o aviso de deletar o arquivo
    /// - Parameter action: ação do botão de deletar
    /// - Returns: pop up de aviso
    private func createDeleteAlert(deleteAction action: @escaping () -> Void) -> UIAlertController {
        let menu = UIAlertController(
            title: "Tem certeza?",
            message: "Tem certeza que deseja exluir o arquivo? Talvez ele não esteja salvo no seu dispositivo.",
            preferredStyle: .alert
        )
        
        let delete = UIAlertAction(title: "Excluir", style: .destructive) { _ in action() }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        menu.addActions([delete, cancel])
        return menu
    }
}
