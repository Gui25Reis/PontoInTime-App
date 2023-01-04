/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elementos de UI da tela de menu
class MenuView: UIView, ViewHasTable, ViewCode {
    
    /* MARK: - Atributos */

    // Views
    
    /// Botão de criar um novo dia
    private lazy var newDayButton: CustomButton = {
        let bt = CustomButton()
        bt.mainColor = .systemBlue
        return bt
    }()
    
    /// Mostra o timer
    private lazy var timerLabel: UILabel = CustomViews.newLabel()
    
    
    /* Protocolos */
    
    // ViewHasTable
    
    /// Tabela com as informações do ponto do dia
    internal var mainTable: CustomTable = CustomTable(style: .justTable)
    
    
    // ViewCode
    
    /// Constraints dinâmicas que mudam de acordo com o tamanho da tela
    internal var dynamicConstraints: [NSLayoutConstraint] = []

    
    
    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        
        self.createView()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Avisa se tem dados na view
    public var hasData = false {
        didSet {
            
            self.setupHierarchy()
            self.updateTimerText(for: "00:00:00")
            self.layoutSubviews()
        }
    }
    
    
    /// Atualiza o texto do timer
    /// - Parameter text: novo texto do timer
    public func updateTimerText(for text: String) {
        self.timerLabel.text = text
    }
        
    
    /* Ações de botões */
    
    /// Define a ação do botão de criar um novo dia
    public func setNewDayAction(target: Any?, action: Selector) -> Void {
        self.newDayButton.addTarget(target, action: action, for: .touchDown)
    }
    
    

    /* MARK: - Ciclo de Vida */
    
    public override func layoutSubviews() {
        super.layoutSubviews()
	      
        self.dynamicCall()
    }
    
    
    
    /* MARK: - Protocolo */
    
    /* ViewCode */
    
    internal func setupHierarchy() {
        switch self.hasData {
        case true:
            self.addSubview(self.mainTable)
            self.newDayButton.removeFromSuperview()
            
        case false:
            self.addSubview(self.newDayButton)
            self.mainTable.removeFromSuperview()
        }
    }
    
    
    internal func setupView() {
        self.backgroundColor = .systemGray6
        
        self.newDayButton.corner = 10 //self.getEquivalent(10)
    }
    
    
    internal func setupFonts() {
        /* Labels */
        self.timerLabel.setupText(with: FontInfo(
            fontSize: self.getEquivalent(70), weight: .light
        ))
        

        /* Botões */
        
        let newDayBtSize = self.getEquivalent(18)
        
        self.newDayButton.setupText(with: FontInfo(
            fontSize: newDayBtSize, weight: .bold
        ))
        
        self.newDayButton.setupIcon(with: IconInfo(icon: .add, size: newDayBtSize))
    }
    
    
    internal func setupStaticTexts() {
        self.newDayButton.text = "Novo dia"
    }
	  
    
    internal func setupDynamicConstraints() {

        // Content
//        let lblBetween: CGFloat = 40
//        let lblHeight = self.getEquivalent(75)

        NSLayoutConstraint.deactivate(self.dynamicConstraints)
        self.dynamicConstraints.removeAll()
        
        
        if self.newDayButton.hasSuperview {
            let lateral: CGFloat = 16
            let btBetween: CGFloat = 20
            let btHeight = self.getEquivalent(44)
            
            self.dynamicConstraints += [
                self.newDayButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: btBetween),
                self.newDayButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
                self.newDayButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
                self.newDayButton.heightAnchor.constraint(equalToConstant: btHeight),
            ]
        }
        
        if self.mainTable.hasSuperview {
            let constraintsStreched = self.mainTable.strechToBounds(of: self)
            self.dynamicConstraints += constraintsStreched
        }
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
    
    
    internal func setupStaticConstraints() {}
    
    internal func setupUI() {}
}
