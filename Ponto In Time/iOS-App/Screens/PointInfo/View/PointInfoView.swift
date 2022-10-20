/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import UIKit


/// O que essa classe faz?
class PointInfoView: UIView {
    
    /* MARK: - Atributos */

    // Views
    
    /// Tabela com as informações do ponto
    private let infosTable: CustomTable = {
        let table = CustomTable(style: .justTable)
        table.setTableTag(for: 0)
        return table
    }()
    
    /// Tabela para os arquivos
    private let fileTable: CustomTable = {
        let table = CustomTable(style: .justTable)
        table.setTableTag(for: 1)
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
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */

    public func setDataSource(with dataSource: PointInfoDataSource) {
        self.infosTable.setDataSource(with: dataSource)
        self.fileTable.setDataSource(with: dataSource)
    }
    
    

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
    private func registerCells() {
        self.infosTable.registerCell(for: PointInfoCell.self)
        self.fileTable.registerCell(for: PointInfoCell.self)
    }

    
    /* Geral */
    
    /// Adiciona os elementos (Views) na tela
    private func setupViews() {
        self.addSubview(self.infosTable)
        self.addSubview(self.fileTable)
    }
    
    
    /// Personalização da UI
    private func setupUI() {
        self.backgroundColor = .systemGray6
    }
    
    
    /// Define os textos que são estáticos (os textos em si que vão sempre ser o mesmo)
    private func setupStaticTexts() {		
        
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
            
            
            self.fileTable.topAnchor.constraint(equalTo: self.infosTable.bottomAnchor, constant: between),
            self.fileTable.leadingAnchor.constraint(equalTo: self.infosTable.leadingAnchor),
            self.fileTable.trailingAnchor.constraint(equalTo: self.infosTable.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
}
