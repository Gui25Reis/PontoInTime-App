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
    internal lazy var mainTable: CustomTable = CustomTable(style: .justTable)
    
    
    // ViewCode
    
    /// Constraints dinâmicas que mudam de acordo com o tamanho da tela
    internal var dynamicConstraints: [NSLayoutConstraint] = []

    
    
    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        
        self.createView()
        self.setupContentView()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Avisa se tem dados na view
    public var hasData = false {
        didSet {
            self.setupContentView()
            self.updateTimerText(for: "00:00:00")
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
//        self.addSubview(self.newDayButton)
//
//        self.addSubview(self.timerLabel)
        self.addSubview(self.mainTable)
    }
    
    
    internal func setupView() {
        self.backgroundColor = .systemGray6
        
        self.newDayButton.layer.cornerRadius = 10 //self.getEquivalent(10)
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
        self.newDayButton.text = "  Novo dia"
    }
	  
    
    internal func setupDynamicConstraints() {
        let lateral: CGFloat = 16
        
        // Botão
        let btBetween: CGFloat = 20
        let btHeight = self.getEquivalent(44)
        
        // Content
        let lblBetween: CGFloat = 40
        let lblHeight = self.getEquivalent(75)

       
        
        let tableHeight = self.mainTable.contentSize.height
        
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
    
        self.dynamicConstraints = [
//            self.newDayButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: btBetween),
//            self.newDayButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
//            self.newDayButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
//            self.newDayButton.heightAnchor.constraint(equalToConstant: btHeight),
//
//
//            self.timerLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: lblBetween),
//            self.timerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
//            self.timerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
//            self.timerLabel.heightAnchor.constraint(equalToConstant: lblHeight),
            
            self.mainTable.topAnchor.constraint(equalTo: self.topAnchor),
//            self.mainTable.topAnchor.constraint(equalTo: self.timerLabel.bottomAnchor, constant: lblBetween),
            self.mainTable.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mainTable.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mainTable.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
//            self.mainTable.heightAnchor.constraint(equalToConstant: tableHeight)
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
    
    
    internal func setupStaticConstraints() {}
    
    internal func setupUI() {}
    
    
    
    /* MARK: - Ciclo de Vida */
    
    /// Configura a tela pra quando tem dado
    private func setupContentView() {
        self.newDayButton.isHidden = self.hasData
        
        self.timerLabel.isHidden = !self.hasData
        self.mainTable.isHidden = !self.hasData
    }
}
