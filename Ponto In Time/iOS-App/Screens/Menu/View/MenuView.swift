/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elementos de UI da tela de menu
class MenuView: UIView {
    
    /* MARK: - Atributos */

    // Views
    
    /// Botão de criar um novo dia
    private lazy var newDayButton: UIButton = {
        let bt = CustomViews.newButton()
        bt.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        
        return bt
    }()
    
    /// Mostra o timer
    private lazy var timerLabel: UILabel = CustomViews.newLabel()
    
    /// Tabela com as informações do ponto do dia
    public lazy var infoTable: CustomTable = {
        let table = CustomTable(style: .justCollection)
        table.setTableTag(for: 0)
        return table
    }()
    
    /// Tabela com os pontos feitos durante o dia
    public lazy var pointsTable: CustomTable = {
        let table = CustomTable(style: .withHeader)
        table.isCustomHeight = true
        table.setTableTag(for: 1)
        
        table.setHeaderTitle(for: "pontos do dia")
        return table
    }()
    
    
    // Outros
    
    /// Constraints dinâmicas que mudam de acordo com o tamanho da tela
    private var dynamicConstraints: [NSLayoutConstraint] = []

    
    // UI
    
    /// Altura do último compontente da view
    private var lastComponentHeight: CGFloat = 0 {
        didSet {
            var maxSpace = self.frame.size.height - self.safeAreaInsets.bottom
            maxSpace -= self.infoTable.frame.height + self.infoTable.frame.origin.y
            
            let status = self.lastComponentHeight > maxSpace
            self.pointsTable.updateScrollStatus(for: status)
        }
    }


    
    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        
        self.setupViews()
        self.registerCell()
        
        self.newDayButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */


    
    

    /* MARK: - Ciclo de Vida */
    
    public override func layoutSubviews() {
        super.layoutSubviews()
	      
        self.setupUI()
        self.setupStaticTexts()
        self.setupDynamicConstraints()
    }
    
    
    
    /* MARK: - Configurações */
    
    /* Table */
    
    /// Registra as células nas collections/table
    private func registerCell() {
        self.infoTable.registerCell(for: InfosMenuCell.self)
        self.pointsTable.registerCell(for: InfosMenuCell.self)
    }
    

    
    /* Geral */
    
    /// Adiciona os elementos (Views) na tela
    private func setupViews() {
        self.addSubview(self.newDayButton)
        
        self.addSubview(self.timerLabel)
        self.addSubview(self.infoTable)
        self.addSubview(self.pointsTable)
    }
    
    
    /// Personalização da UI
    private func setupUI() {
        self.backgroundColor = .systemGray6
        
        self.newDayButton.layer.cornerRadius = self.getEquivalent(10)
    }
    
    
    /// Define os textos que são estáticos (os textos em si que vão sempre ser o mesmo)
    private func setupStaticTexts() {		
        /* Labels */
        self.timerLabel.setupText(with: FontInfo(
            text: "03:46:21", fontSize: self.getEquivalent(70), weight: .light
        ))
        

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
        let bottomGap: CGFloat = 5
        
        // Botão
        let butBetween: CGFloat = 20
        
        let btHeight = self.getEquivalent(44)
        
        // Content
        let lblBetween: CGFloat = 40
        
        let lblHeight: CGFloat = self.getEquivalent(75)

       
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
    
        self.dynamicConstraints = [
            self.newDayButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: butBetween),
            self.newDayButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
            self.newDayButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
            self.newDayButton.heightAnchor.constraint(equalToConstant: btHeight),
            
            
            self.timerLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: lblBetween),
            self.timerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
            self.timerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
            self.timerLabel.heightAnchor.constraint(equalToConstant: lblHeight),
            
            
            self.infoTable.topAnchor.constraint(equalTo: self.timerLabel.bottomAnchor, constant: lblBetween),
            self.infoTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
            self.infoTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
            
            
            self.pointsTable.topAnchor.constraint(equalTo: self.infoTable.bottomAnchor, constant: lblBetween),
            self.pointsTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
            self.pointsTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
            self.pointsTable.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomGap)
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
        
        self.lastComponentHeight = self.pointsTable.frame.height
    }
}