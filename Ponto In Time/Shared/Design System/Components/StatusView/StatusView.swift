/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Cria o símbolo de estado: Entrada ou Saída
class StatusView: UILabel {
    
    /* MARK: - Atributos */
    
    /// Tamanho do quadrado
    public var squareSize: CGFloat = 25 {
        didSet {
            self.setupDynamicConstraints()
        }
    }
    
    /* Constraints & Tamanhos */
        
    /// Constraints dinâmicas que mudam de acordo com o tamanho da tela
    private lazy var dynamicConstraints: [NSLayoutConstraint] = []
    
    

    /* MARK: - Construtor */
    
    /// Define o tipo de status
    /// - Parameter status: status
    init(status: StatusViewStyle) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setupUI(for: status)
        self.setupDynamicConstraints()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    

    /* MARK: - Configurações */

    /* Geral */

    /// Personalização da UI
    private func setupUI(for status: StatusViewStyle) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(status.color)
        self.textAlignment = .center
        
        self.text = status.letter
    }
    
    
    /// Define as constraints que dependem do tamanho da tela
    private func setupDynamicConstraints() {
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
    
        self.dynamicConstraints = [
            self.heightAnchor.constraint(equalToConstant: self.squareSize),
            self.widthAnchor.constraint(equalToConstant: self.squareSize)
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
}
