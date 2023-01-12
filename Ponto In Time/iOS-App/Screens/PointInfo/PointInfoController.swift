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
    
    
    internal func deleteFileAction() {
        let alert = self.createDeleteAlert()
        self.showAlert(alert)
    }
    
    
    
    /* DocumentsHandlerDelegate */
    
    internal func documentSelected(_ document: ManagedFiles?, image: UIImage?) {
        guard let document, var tableData = self.pointInfoHanlder.mainData
        else { print("Não deu certo"); return }
        
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
    
    
    /// Abre um dos tipos de seleçào de arquivos
    /// - Parameter type: tipo de seleção de arquivo
    private func showPicker(for type: PickerType) {
        let picker = self.documentsHandler.createPicker(for: type)
        guard let picker else { return }
        self.present(picker, animated: true)
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
        
        // Botões
        menu.addAction(UIAlertAction(title: "Tirar foto", style: .default) { _ in
            self.showPicker(for: .camera)
        })
        
        menu.addAction(UIAlertAction(title: "Escolher foto", style: .default) { _ in
            self.showPicker(for: .photos)
        })
        
        menu.addAction(UIAlertAction(title: "Escolher documento", style: .default) { _ in
            self.showPicker(for: .files)
        })

        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        cancel.setValue(UIColor.systemRed, forKey: "titleTextColor")
        menu.addAction(cancel)
        
        return menu
    }
    
    
    /// Cria o aviso de deletar o arquivo
    /// - Returns: Aviso
    private func createDeleteAlert() -> UIAlertController {
        let menu = UIAlertController(
            title: "Tem certeza?",
            message: "Tem certeza que deseja exluir o arquivo? Talvez ele não esteja salvo no seu dispositivo.",
            preferredStyle: .alert
        )
        
        menu.addAction(UIAlertAction(title: "Excluir", style: .destructive) { _ in
            
        })
        
        menu.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        return menu
    }
}
