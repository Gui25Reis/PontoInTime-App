/* Gui Reis    -    gui.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Controller responsável pela tela de edição de um texto/dado
class TextEditController: UIViewController, ControllerActions, ViewHasTextField {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = TextEditView()
    
    
    /* Delegate & Handlers */
    
    /// Delegate do text field
    private let textFieldDelegate = TextFieldDelegate()
    
    /// Comuicação com a controller (tela) anterior
    private var textEditDelegate: TextEditProtocol
    
    
    /* Outros */
    
    /// Dados que a controller vai usar
    private var data: TextEditData
    
    /// Valor boleano que diz se o dado está sendo excluindo
    private var isDeleting = false
    
    
    
    /* MARK: - Construtor */
    
    init(data: TextEditData, delegate: TextEditProtocol) {
        self.data = data
        self.textEditDelegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
        
    /* MARK: - Ciclo de Vida */
    
    override func loadView() {
        self.view = self.myView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupController()
        self.setupView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.myView.showKeyboard()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard !self.isDeleting else { return }
        self.returnTextEdited()
    }
    
    
    
    /* MARK: - Ações */
    
    @objc private func deleteAction() {
        let alert = self.createDeleteAlert()
        self.present(alert, animated: true)
    }
    
    
    
    /* MARK: - Protocolos */
    
    // ViewHasTextField
    
    internal func dismissAction() {
        guard isDataValidated() else { return }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Controller Actions
    
    internal func setupNavigation() {
        self.title = self.data.title
        self.navigationItem.largeTitleDisplayMode = .never
        
        if self.data.isDeletable {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Deletar",
                style: .plain,
                target: self,
                action: #selector(self.deleteAction)
            )
            self.navigationItem.rightBarButtonItem?.tintColor = .systemRed
        }
    }
    
    
    internal func setupDelegates() {
        self.textFieldDelegate.delegate = self
        self.myView.setTextFieldDelegate(with: self.textFieldDelegate)
    }
    
    
    internal func setupButtonsAction() {}
    
    
    
    /* MARK: - Configurações */
    
    /// Configura a view
    private func setupView() {
        self.myView.setupView(for: self.data)
        
        self.textFieldDelegate.maxLenght = self.data.maxDataLenght
    }
    
    
    /* Dados */
    
    /// Retorna o texto que foi editado
    private func returnTextEdited() {
        guard self.isDataValidated() else { return }
        
        let dataEdited = DataEdited(
            oldData: self.data.defaultData?.capitalized,
            newData: self.myView.textEdited
        )
        
        self.textEditDelegate.dataEditHandler(data: dataEdited)
    }
    
    
    /// Vertifica se o dado editado é válido
    /// - Returns: boleano que indica se o dado é válido ou não
    private func isDataValidated() -> Bool {
        let textEdited = self.myView.textEdited
        
        if self.data.isNumeric {
            guard textEdited.isNumberInt else {
                self.showPopUp(for: .dataIsNotNumeric)
                return false
            }
            
            if let range = self.data.rangeAllowed {
                guard let number = Int(textEdited) else { return false }
                
                if !range.checkInside(value: number) {
                    self.showPopUp(for: .rangeError(range: range))
                    return false
                }
            }
        } else {
            guard textEdited.isAlphabetic else {
                self.showPopUp(for: .symbolsNotAllowed)
                return false
            }
        }
        
        return true
    }
    
    
    /// Mostra um pop up a partir de um erro do tipo `ErrorTextEdit`
    /// - Parameter error: erro
    private func showPopUp(for error: ErrorTextEdit) {
        self.showWarningPopUp(with: error)
    }
    
    
    /* Deletar */
    
    /// Faz a deleção dos dados
    private func deleteHandler() {
        let dataEdit = DataEdited(oldData: self.data.defaultData ?? "", hasDeleted: true)
        self.textEditDelegate.dataEditHandler(data: dataEdit)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /// Cria o pop up de alerta para deleção de um dado
    private func createDeleteAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Atenção",
            message: "Tem certeza que deseja excluir?",
            preferredStyle: .alert
        )
        
        let delete = UIAlertAction(title: "Excluir", style: .destructive) { _ in self.deleteHandler() }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        return alert
    }
}
