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
    
    
    /* Outros */
    
    /// Tipo de status
    public var status: StatusViewStyle = .start {
        didSet {
            self.setStatusInfo(for: self.status)
        }
    }
    
    

    /* MARK: - Construtor */
    
    /// Define o tipo de status
    /// - Parameter status: status
    init(status: StatusViewStyle = .start) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setupUI()
        self.setStatusInfo(for: status)
        self.setupDynamicConstraints()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

        

    /* MARK: - Configurações */
    
    
    private func setStatusInfo(for status: StatusViewStyle) {
        self.backgroundColor = UIColor(status.color)
        self.text = status.letter
    }
    
    /* Geral */

    /// Personalização da UI
    private func setupUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.textAlignment = .center
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
    
    
    /// Pega uma imagem a partir do componente de status (UIView -> UIImage)
    /// - Parameter status: tipo do componente
    /// - Returns: imagem do componente
    static func getImage(for status: StatusViewStyle) -> UIImage {
        let view = StatusView(status: status)
        
        let size = view.squareSize
        view.bounds.size = CGSize(width: size, height: size)

        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { render in
            view.layer.render(in: render.cgContext)
        }
        
        return image
    }
    
    
    /// Pega uma imagem a partir do componente de status (UIView -> UIImage)
    /// - Parameter status: tipo do componente
    /// - Returns: imagem do componente
    static func getImage(for status: String) -> UIImage {
        for item in StatusViewStyle.allCases {
            if status == item.word {
                return Self.getImage(for: item)
            }
        }
        
        return UIImage()
    }
    
    
    /// Pega uma imagem a partir do componente de status (UIView -> UIImage)
    /// - Parameter status: tipo do componente
    /// - Returns: imagem do componente
    static func getCase(for status: String) -> StatusViewStyle {
        for item in StatusViewStyle.allCases {
            if status == item.word {
                return item
            }
        }
        return .start
    }
}
