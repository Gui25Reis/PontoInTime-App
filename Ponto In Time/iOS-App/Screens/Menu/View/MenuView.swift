/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import UIKit


/// O que essa classe faz?
class MenuView: UIView {
    
    /* MARK: - Atributos */

    // Views
    
    /// Botão de criar um novo dia
    private lazy var newDayButton: UIButton = {
        let bt = CustomViews.newButton()
        bt.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        
        return bt
    }()
    
    
    // Outros
    
    /// Constraints dinâmicas que mudam de acordo com o tamanho da tela
    private var dynamicConstraints: [NSLayoutConstraint] = []




    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */

    /* Ações de botões */

    /// Ação do botão X
//    public func setButtonAction(target: Any?, action: Selector) -> Void {
//        self.someButton.addTarget(target, action: action, for: .touchDown)
//    }
    
    

    /* MARK: - Ciclo de Vida */
    
    public override func layoutSubviews() {
        super.layoutSubviews()
	      
        self.setupUI()
        self.setupStaticTexts()
        self.setupDynamicConstraints()
    }
    
    
    
    /* MARK: - Configurações */

    /* Geral */
    
    /// Adiciona os elementos (Views) na tela
    private func setupViews() {
        self.addSubview(self.newDayButton)
    }
    
    
    /// Personalização da UI
    private func setupUI() {
        self.backgroundColor = .systemGray6
        
        self.newDayButton.layer.cornerRadius = self.getEquivalent(10)
    }
    
    
    /// Define os textos que são estáticos (os textos em si que vão sempre ser o mesmo)
    private func setupStaticTexts() {		
        /* Labels */
        
        

        /* Botões */
        
        let newDayBtSize = self.getEquivalent(18)
        
        self.newDayButton.setupText(with: FontInfo(
            text: "  Novo dia" , fontSize: newDayBtSize, weight: .bold
        ))
        
        self.newDayButton.setupIcon(with: IconInfo(icon: .add, size: newDayBtSize))
        
        
    }
	  
    
    /// Define as constraints que dependem do tamanho da tela
    private func setupDynamicConstraints() { 
        let lateral: CGFloat = 16
        let between: CGFloat = 20
        
        let btHeight = self.getEquivalent(44)
       
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
    
        self.dynamicConstraints = [
            self.newDayButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: between),
            self.newDayButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
            self.newDayButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
            self.newDayButton.heightAnchor.constraint(equalToConstant: btHeight)
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
}
