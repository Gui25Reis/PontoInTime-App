/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elemento de UI da célula da tabela de pontos da tela de configurações
class SeetingsPointsCell: GeneralTableCell, CustomCell {
    
    /* MARK: - Atributos */
    
    /// Botão de deletar uma célula
    private lazy var deleteButton: UIButton = {
        let but = CustomViews.newButton()
        but.isHidden = true
        but.tintColor = .systemRed
        return but
    }()

    
    // Outros

    /// Constraints que vão mudar de acordo com o tamanho da tela
    private var dynamicConstraints: [NSLayoutConstraint] = []
    
    
    
    /* MARK: - Protocolo */
    
    static var identifier: String = "IdSeetingsPointsCell"
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Configura a célula de acordo com o dado passado
    /// - Parameter data: dado
    public func setupCell(for data: ManagedPointType) {
        self.setupCellData(with: CellData(primaryText: data.title))
        self.setupDeleteButtom(for: data.isDefault)
    }
    
    
    /* Ações de botões */
        
    /// Define a ação do botão de voltar
    public func setDeleteAction(target: Any?, action: Selector) -> Void {
        self.deleteButton.addTarget(target, action: action, for: .touchDown)
        self.deleteButton.tag = self.tag
    }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.deleteButton.superview != nil {
            self.setupStaticTexts()
            self.setupDynamicConstraints()
        }
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configura o botão de deletar
    /// - Parameter status: visibilidade do botão
    private func setupDeleteButtom(for status: Bool) {
        self.deleteButton.isHidden = status
        
        if !status {
            self.contentView.addSubview(self.deleteButton)
            self.layoutSubviews()
        }
    }
    
    
    /// Define os textos que são estáticos (os textos em si que vão sempre ser o mesmo)
    private func setupStaticTexts() {
        self.deleteButton.setupIcon(with: IconInfo(icon: .delete, size: 16))
    }
    
    
    /// Define as constraints que dependem do tamanho da tela
    private func setupDynamicConstraints() {
        let lateral: CGFloat = 16
        
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
        self.dynamicConstraints.removeAll()
    
        self.dynamicConstraints = [
            self.deleteButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -lateral),
            self.deleteButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
}
