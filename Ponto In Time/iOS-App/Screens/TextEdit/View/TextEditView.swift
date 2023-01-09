/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct CoreGraphics.CGFloat
import class Foundation.NSCoder

import class UIKit.UIView
import class UIKit.NSLayoutConstraint



/// Elementos de UI da tela de editar um texto/dado
class TextEditView: UIView, ViewCode {
    
    /* MARK: - Atributos */
    
    // Views
    
    /// Espaço para edição de texto
    private lazy var textField: CustomTextField = {
        let txt = CustomTextField()
        txt.keyboardType = .numberPad
        return txt
    }()
    
    
    /* Protocolos */
    
    // ViewCode
    internal var dynamicConstraints: [NSLayoutConstraint] = []
    
    
    
    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        self.createView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Texto que foi editado
    public var textEdited: String { self.textField.text ?? "" }
    
    
    /// Define a ação do textfield quando muda o texto
    public func setTextFieldDelegate(with delegate: TextFieldDelegate) {
        self.textField.delegate = delegate
    }
    
    
    /// Configuração da view a partir dos dados
    /// - Parameter data: dados iniciais
    public func setupView(for data: TextEditData) {
        self.textField.text = data.defaultData
        self.textField.becomeFirstResponder()
        
        if data.isNumeric {
            self.textField.keyboardType = .numbersAndPunctuation
        } else {
            self.textField.keyboardType = .default
        }
    }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.dynamicCall()
    }
    
    
    
    /* MARK: - Protocolo */
    
    /* ViewCode */
    
    internal func setupHierarchy() {
        self.addSubview(self.textField)
    }
    
    
    internal func setupView() {
        self.backgroundColor = .systemGray6
        
        self.textField.corner = 10
        self.textField.lateralPadding = 16
    }
    
    
    internal func setupFonts() {
        self.textField.setupFont(with: FontInfo(
            fontSize: self.getEquivalent(18), weight: .regular
        ))
    }
    
    
    internal func setupDynamicConstraints() {
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
        self.dynamicConstraints.removeAll()
        
        let lateral: CGFloat = 16
        let btBetween: CGFloat = 20
        let btHeight = self.getEquivalent(44)
        
        self.dynamicConstraints = [
            self.textField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: btBetween),
            self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
            self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
            self.textField.heightAnchor.constraint(equalToConstant: btHeight),
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
    
    
    internal func setupStaticConstraints() {}
    
    internal func setupUI() {}
    
    internal func setupStaticTexts() {}
}
