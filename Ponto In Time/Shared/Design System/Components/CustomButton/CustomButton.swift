/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Botão costumizado
class CustomButton: UIButton {
    
    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Override */
    
    // Quando possui um menu deixa ele como prioridade de ação
    override var menu: UIMenu? {
        didSet { self.showsMenuAsPrimaryAction = true }
    }
    
    
    // Muda a posição que o UIMenu vai ser apresentado (para o canto direito)
    override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
        let original = super.menuAttachmentPoint(for: configuration)
        return CGPoint(x: self.frame.maxX, y: original.y)
    }
    
    
    // Quando atualizar a imagem atualiza o texto junto
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        
        let text = text
        self.text = text
    }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Cor principal do botão
    public var mainColor: UIColor? {
        didSet { self.setupColor() }
    }
    
    
    /// Texto do botão
    public var text: String? {
        didSet { self.setupText() }
    }
    
    
    /// Define a curvatura das bordas do botão
    public var corner: CGFloat = 0 {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = self.corner
        }
    }
    
    
    /* Variáveis computáveis */
    
    /// Boleano que indica se possui um ícone
    public var hasIcon: Bool { self.imageView?.hasImage ?? false}
        
    
    /* IconInfo */
    
    /// Configura o ícone do botão a partir da configuração passada
    /// - Parameter config: Modelo de informações do texto e fonte
    public func setupIcon(with config: IconInfo) -> Void {
        let image = UIImage.getImage(with: config)
        self.setImage(image, for: .normal)
    }

    
    
    /* MARK: - Configurações */
    
    /// Configurações iniciais
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    /// Configura as cores a partir da cor principal
    private func setupColor() {
        guard let color = self.mainColor else { return }
        
        self.backgroundColor = color.withAlphaComponent(0.2)
        self.setTitleColor(color, for: .normal)
        self.tintColor = color
    }
    
    
    /// Configura o texto do botão
    private func setupText() {
        guard let text = self.text else { return }
        
        var str = text
        if self.hasIcon { str = "  " + str }
        
        self.setTitle(str, for: .normal)
    }
}
