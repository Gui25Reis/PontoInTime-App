/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elemento de UI da célula da tela de ajustes
class SettingsView: UIView, ViewHasTable {
    
    var mainTable: CustomTable = CustomTable(style: .complete)
    
    
    /* MARK: - Atributos */

    // Views
    
    /// Tabela com as informações gerais
//    private let infosTable: CustomTable = {
//        let table = CustomTable(style: .justTable)
//        table.setTableTag(for: 0)
//
//        return table
//    }()
//
//    /// Tabela com as informações de compartilhamento
//    private let shareTable: CustomTable = {
//        let table = CustomTable(style: .complete)
//        table.setTableTag(for: 1)
//
//        // TODO: MVP
//        table.isUserInteractionEnabled = false
//
//        return table
//    }()
//
//    /// Tabela com as informações dos tipos de pontos disponíveis
//    private let pointTable: CustomTable = {
//        let table = CustomTable(style: .withHeader)
//        table.setTableTag(for: 2)
//
//        return table
//    }()
    
    
    // Outros
    
    /// Constraints dinâmicas que mudam de acordo com o tamanho da tela
    private var dynamicConstraints: [NSLayoutConstraint] = []



    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        
        self.setupViews()
        self.setupStaticTexts()
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
    
    
    /// Define os textos que são estáticos (os textos em si que vão sempre ser o mesmo)
    private func setupStaticTexts() {
//        self.pointTable.setHeaderTitle(for: "Pontos")
//
//        self.shareTable.setHeaderTitle(for: "Compartilhamento")
//
//        let footerText = "Compartilha apenas o seu horário, podendo ver no site do app através do seu id"
//        self.shareTable.setFooterTitle(for: footerText)
    }
	  
    
    /// Define as constraints que dependem do tamanho da tela
    private func setupDynamicConstraints() { 
//        let lateral: CGFloat = self.getEquivalent(16)
//        let between: CGFloat = self.getEquivalent(40)
        
        if !self.dynamicConstraints.isEmpty {
            NSLayoutConstraint.deactivate(self.dynamicConstraints)
            self.dynamicConstraints.removeAll()
        }
        
        self.dynamicConstraints = [
//            self.infosTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: lateral),
//            self.infosTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateral),
//            self.infosTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateral),
//
//
//            self.shareTable.topAnchor.constraint(equalTo: self.infosTable.bottomAnchor, constant: between),
//            self.shareTable.leadingAnchor.constraint(equalTo: self.infosTable.leadingAnchor),
//            self.shareTable.trailingAnchor.constraint(equalTo: self.infosTable.trailingAnchor),
//
//
//            self.pointTable.topAnchor.constraint(equalTo: self.shareTable.bottomAnchor, constant: between),
//            self.pointTable.leadingAnchor.constraint(equalTo: self.infosTable.leadingAnchor),
//            self.pointTable.trailingAnchor.constraint(equalTo: self.infosTable.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
}
