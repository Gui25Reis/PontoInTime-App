/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elementos de UI da tela de histórico
class HistoricView: UIView {
    
    /* MARK: - Atributos */

    // Views
    
    /// Tabela de histórico
    public let historicTable: CustomTable = {
        let table = CustomTable(style: .justTable)
        table.setTableHeight(for: 65)
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
        self.historicTable.registerCell(for: HistoricCell.self)
    }


    /* Geral */
    
    /// Adiciona os elementos (Views) na tela
    private func setupViews() {
        self.addSubview(self.historicTable)
    }
    
    
    /// Personalização da UI
    private func setupUI() {
        self.backgroundColor = .systemGray6
        self.historicTable.setTableHeight(for: self.getEquivalent(65))
    }
    
    
    /// Define os textos que são estáticos (os textos em si que vão sempre ser o mesmo)
    private func setupStaticTexts() {		
        
    }
	  
    
    /// Define as constraints que dependem do tamanho da tela
    private func setupDynamicConstraints() { 
        let lateral: CGFloat = self.getEquivalent(16)
    
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
    
        self.dynamicConstraints = [
            self.historicTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: lateral),
            self.historicTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
            self.historicTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
}
