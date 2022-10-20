/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elemento de UI da célula das tabelas da tela de configurações
class SettingsCell: GeneralTableCell, CustomCell {
    
    /* MARK: - Atributos */
    
    /// Botào de ligado/desligado
    private let switchButton: UISwitch = {
        let but = CustomViews.newSwitch()
        but.isOn = true
        but.isHidden = true
        
        return but
    }()
    
    
    // Outros

    /// Constraints que vão mudar de acordo com o tamanho da tela
    private var dynamicConstraints: [NSLayoutConstraint] = []
    
    
    
    /* MARK: - Construtor */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Protocolo */
    
    static var identifier: String = "IdSettingsCell"
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Define se o switch vai ser mostrado o não
    /// - Parameter status: visibilidade do switch
    public func updateSwitchVisibility(for status: Bool) {
        self.switchButton.isHidden = !status
    }
    
    

    /* MARK: - Ciclo de Vida */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
        self.setupDynamicConstraints()
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Adiciona os elementos (Views) na tela
    private func setupViews() {
        if self.switchButton.superview == nil {
            self.contentView.addSubview(self.switchButton)
        }
    }
      
    
    /// Define as constraints que dependem do tamanho da tela
    private func setupDynamicConstraints() {
        let lateral: CGFloat = 16
       
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
    
        self.dynamicConstraints = [
            self.switchButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -lateral),
            self.switchButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
}
