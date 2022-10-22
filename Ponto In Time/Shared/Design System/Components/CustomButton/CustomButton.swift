/* Macro - Grupo 05 */

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
    
    override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
        let original = super.menuAttachmentPoint(for: configuration)
        return CGPoint(x: self.frame.maxX, y: original.y)
    }
    

    
    /* MARK: - Configurações */
    
    /// Configurações iniciais
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        
        self.setTitleColor(.systemBlue, for: .normal)
    }
}
