/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Campo de texto costumizado
class CustomTextField: UITextField {
    
    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Override */
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.textInsets)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.textInsets)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.textInsets)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var original = super.clearButtonRect(forBounds: bounds)
        original.origin.x -= self.clearButPadding
        
        return original
    }
    

    
    /* MARK: - Encapsulamento */
    
    /// Esoaço lateral interno do botão
    public var lateralPadding: CGFloat = 0 {
        didSet {
            self.textPadding = self.lateralPadding
            self.clearButPadding = self.lateralPadding/2
        }
    }
    
    /// Espaço interno esquerdo do texto
    public var textPadding: CGFloat = 0 {
        didSet {
            self.textInsets = UIEdgeInsets(top: 0, left: self.textPadding, bottom: 0, right: 0)
        }
    }
    
    /// Espaço interno esquerdo do botão
    public var clearButPadding: CGFloat = 0
    
    /// Espaço interno do texto
    public var textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    
    /// Define a curvatura das bordas do botão
    public var corner: CGFloat = 0 {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = self.corner
        }
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configurações iniciais
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.returnKeyType = .done
        self.clearButtonMode = .whileEditing
        
        self.backgroundColor = UIColor(.tableColor)
        self.textColor = .label
    }
}
