/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Cria o símbolo de estado: Entrada ou Saída
class StatusView: UIView {
    
    /* MARK: - Atributos */

    /* Views */
    
    /// Letra
    private lazy var charLabel = CustomViews.newLabel()
    
    
    /* Constraints & Tamanhos */
    
    /// Constraints dinâmicas que mudam de acordo com o tamanho da tela
    private lazy var dynamicConstraints: [NSLayoutConstraint] = []
    
    /// Tamanho do quadrado
    private lazy var squareSize: CGFloat = 25 {
        didSet {
            self.setupDynamicConstraints()
        }
    }
    


    /* MARK: - Construtor */
    
    /// Define o tipo de status
    /// - Parameter status: status
    init(status: StatusViewStyle) {
        super.init(frame: .zero)
        
        self.setupViews()
        self.setupUI(for: status)
        self.setupStaticConstraints()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    

    /* MARK: - Ciclo de Vida */
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupStaticTexts()
        self.setupDynamicConstraints()
    }
    
    
    
    /* MARK: - Configurações */

    /* Geral */
    
    /// Adiciona os elementos (Views) na tela
    private func setupViews() {
        self.addSubview(self.charLabel)
    }
    
    
    /// Personalização da UI
    private func setupUI(for status: StatusViewStyle) {
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(status.color)
        
        self.charLabel.text = status.letter
    }
    
    
    /// Define os textos que são estáticos (os textos em si que vão sempre ser o mesmo)
    private func setupStaticTexts() {
        let size: CGFloat = self.bounds.height * 0.65
        
        self.charLabel.setupText(with: FontInfo(
            fontSize: size, weight: .regular
        ))
    }
	  
    
    /// Define as constraints estáticas
    private func setupStaticConstraints() {
        NSLayoutConstraint.activate([
            self.charLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.charLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.charLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.charLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
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
