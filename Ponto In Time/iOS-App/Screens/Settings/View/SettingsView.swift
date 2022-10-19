/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import UIKit


/// O que essa classe faz?
class SettingsView: UIView {
    
    /* MARK: - Atributos */

    // Views
    
    private let infosTable: CustomTable = {
        let table = CustomTable(style: .justTable)
        table.setTableTag(for: 0)
        
        return table
    }()
    
    
    private let shareTable: CustomTable = {
        let table = CustomTable(style: .complete)
        table.setTableTag(for: 1)
        
        return table
    }()
    
    
    private let pointTable: CustomTable = {
        let table = CustomTable(style: .withHeader)
        table.setTableTag(for: 2)
        
        return table
    }()
    
    
    
    
    // Outros
    
    /// Constraints dinâmicas que mudam de acordo com o tamanho da tela
    private var dynamicConstraints: [NSLayoutConstraint] = []



    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        
        self.setupViews()
        self.registerCells()
        self.setupStaticTexts()
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */

    public func setDataSource(with dataSource: SettingsDataSource) {
        self.infosTable.setDataSource(with: dataSource)
        self.shareTable.setDataSource(with: dataSource)
        self.pointTable.setDataSource(with: dataSource)
    }
    
    

    /* MARK: - Ciclo de Vida */
    
    public override func layoutSubviews() {
        super.layoutSubviews()
	      
        self.setupDynamicConstraints()
    }
    
    
    
    /* MARK: - Configurações */

    /* Collection */
    
    /// Registra as células nas collections/table
    private func registerCells() {
        self.infosTable.registerCell(for: SettingsCell.self)
        self.shareTable.registerCell(for: SettingsCell.self)
        self.pointTable.registerCell(for: SettingsCell.self)
    }


    /* Geral */
    
    /// Adiciona os elementos (Views) na tela
    private func setupViews() {
        self.addSubview(self.infosTable)
        self.addSubview(self.shareTable)
        self.addSubview(self.pointTable)
    }
    
    
    /// Personalização da UI
    private func setupUI() {
        self.backgroundColor = .systemGray6
    }
    
    
    /// Define os textos que são estáticos (os textos em si que vão sempre ser o mesmo)
    private func setupStaticTexts() {
        self.pointTable.setHeaderTitle(for: "Pontos")
        
        self.shareTable.setHeaderTitle(for: "Compartilhamento")
        
        let footerText = "Compartilha apenas o seu horário, podendo ver no site do app através do seu id"
        self.shareTable.setFooterTitle(for: footerText)
    }
	  
    
    /// Define as constraints que dependem do tamanho da tela
    private func setupDynamicConstraints() { 
        let lateral: CGFloat = self.getEquivalent(16)
        let between: CGFloat = self.getEquivalent(40)
       
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
        self.dynamicConstraints.removeAll()
        
        self.dynamicConstraints = [
            self.infosTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: lateral),
            self.infosTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
            self.infosTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
            
            
            self.shareTable.topAnchor.constraint(equalTo: self.infosTable.bottomAnchor, constant: between),
            self.shareTable.leadingAnchor.constraint(equalTo: self.infosTable.leadingAnchor),
            self.shareTable.trailingAnchor.constraint(equalTo: self.infosTable.trailingAnchor),
            
            
            self.pointTable.topAnchor.constraint(equalTo: self.shareTable.bottomAnchor, constant: between),
            self.pointTable.leadingAnchor.constraint(equalTo: self.infosTable.leadingAnchor),
            self.pointTable.trailingAnchor.constraint(equalTo: self.infosTable.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
}