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
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Override */
    
    // Muda a posição que o UIMenu vai ser apresentado
    override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
        let original = super.menuAttachmentPoint(for: configuration)
        return CGPoint(x: self.frame.maxX, y: original.y)
    }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Cor principal do botão
    public var mainColor: UIColor? {
        didSet {
            self.setupColor()
        }
    }

    
    
    /* MARK: - Configurações */
    
    /// Configurações iniciais
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
    }
    
    
    /// Configura as cores a partir da cor principal
    private func setupColor() {
        if let color = self.mainColor {
            self.backgroundColor = color.withAlphaComponent(0.2)
            self.setTitleColor(color, for: .normal)
            self.tintColor = color
        }
    }
}
