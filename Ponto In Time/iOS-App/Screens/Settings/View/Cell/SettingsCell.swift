/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elemento de UI da célula das tabelas da tela de configurações
class SettingsCell: GeneralTableCell, CustomCell {
    
    /* MARK: - Atributos */
    
    /// Botão de ligado/desligado
    private let switchButton: UISwitch = {
        let but = CustomViews.newSwitch()
        but.isOn = true
        but.isHidden = true
        
        return but
    }()

    
    // Outros

    /// Constraints que vão mudar de acordo com o tamanho da tela
    private var dynamicConstraints: [NSLayoutConstraint] = []
    
    
    
    /* MARK: - Protocolo */
    
    static var identifier: String = "IdSettingsCell"
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Define se o switch vai ser mostrado o não
    /// - Parameter status: visibilidade do switch
    public func updateSwitchVisibility(for status: Bool) {
        self.switchButton.isHidden = !status
    }
    
    
    /// Define se o switch vai ser mostrado o não
    /// - Parameter status: visibilidade do switch
    public func updateSwitchStatus(for status: Bool) {
        self.switchButton.isOn = status
    }



    /* MARK: - Ciclo de Vida */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
        self.setupDynamicConstraints()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.switchButton.removeFromSuperview()
        
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
        self.dynamicConstraints.removeAll()
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
            self.switchButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
}
