/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elemento de UI da célula das tabelas da tela de informações de um ponto
class PointInfoView: UIView, ViewHasTable {
    
    /* MARK: - Atributos */

    // Views
    
    var mainTable: CustomTable = CustomTable(style: .justTable)

    
    
    // Outros
    
    /// Constraints dinâmicas que mudam de acordo com o tamanho da tela
    private var dynamicConstraints: [NSLayoutConstraint] = []
		
    

    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        
        self.setupViews()
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Protocolo */
    
    
    
    

    /* MARK: - Ciclo de Vida */
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupDynamicConstraints()
    }
    
    
    
    /* MARK: - Configurações */

    
    /* Geral */
    
    /// Adiciona os elementos (Views) na tela
    private func setupViews() {
        
    }
    
    
    /// Personalização da UI
    private func setupUI() {
        self.backgroundColor = .systemGray6
    }
	  
    
    /// Define as constraints que dependem do tamanho da tela
    private func setupDynamicConstraints() { 
//        let lateral: CGFloat = self.getEquivalent(16)
//        let between: CGFloat = self.getEquivalent(40)
        
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
        self.dynamicConstraints.removeAll()
        
        self.dynamicConstraints = [
//            self.infosTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: lateral),
//            self.infosTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
//            self.infosTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
//
//
//            self.fileTable.topAnchor.constraint(equalTo: self.infosTable.bottomAnchor, constant: between),
//            self.fileTable.leadingAnchor.constraint(equalTo: self.infosTable.leadingAnchor),
//            self.fileTable.trailingAnchor.constraint(equalTo: self.infosTable.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
}
