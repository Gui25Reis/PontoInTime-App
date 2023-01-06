/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct CoreGraphics.CGFloat
import class UIKit.UILabel
import class UIKit.NSLayoutConstraint


/// Elemento de UI da célula das tabelas da tela de menu inicial
class HistoricCell: TableCell {
    
    /* MARK: - Atributos */
    
    // Views
    
    /// Stacks para colocar as views
    private let stackView = CustomStack(axis: .vertical, sameDimension: .width)
    
    /// Mostra a data
    private let dateLabel = CustomViews.newLabel(align: .left)
    
    /// Mostra a quantidade de horas trabalhadas
    private let workTimeLabel: UILabel = {
        let lbl = CustomViews.newLabel(align: .left)
        lbl.textColor = .secondaryLabel
        return lbl
    }()
   
    
    // Outros
    
    /// Diz se as view ja foram adicionadas
    private var hasViews = false
    
    
    
    /* MARK: - Override */
    
    internal override func setupHierarchy() {}
    
    
    internal override func setupData(with data: TableData) {
        self.setupViews()
        
        let fontSize = self.dateLabel.font.pointSize
        
        self.dateLabel.setupTextWithIcon(
            text: data.primaryText ?? "",
            icon: IconInfo(icon: .calendar, size: fontSize)
        )
        self.dateLabel.setupFont(with: FontInfo(fontSize: fontSize, weight: .medium))
        
        if let timeWork = data.secondaryText {
            self.workTimeLabel.text = "Tempo de trabalho: \(timeWork)"
        }
        
        self.setupRightIcon(for: data.rightIcon)
    }
    
    
    internal override func setupFonts() {
        super.setupFonts()
        guard self.hasViews else { return }
        
        let fontSize: CGFloat = self.superview?.getEquivalent(18) ?? 18
        
        self.dateLabel.setupFont(with: FontInfo(
            fontSize: fontSize, weight: .medium
        ))
        
        self.workTimeLabel.setupFont(with: FontInfo(
            fontSize: fontSize, weight: .regular
        ))
    }
	  
    
    internal override func setupDynamicConstraints() {
        super.setupDynamicConstraints()
        guard self.hasViews else { return }
        
        // Espaçamentos
        let lblHeight: CGFloat = self.superview?.getEquivalent(20) ?? 20
        let between: CGFloat = self.stackView.getEqualSpace(for: lblHeight)
        
        var constraints = self.dynamicConstraints
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
        
        constraints += [
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: between),
            self.stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: self.lateralSpace),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -between),
            
            
            self.dateLabel.heightAnchor.constraint(equalToConstant: lblHeight),
            self.workTimeLabel.heightAnchor.constraint(equalToConstant: lblHeight),
        ]
        
        self.dynamicConstraints = constraints
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Adiciona os elementos (Views) na tela
    private func setupViews() {
        guard !self.hasViews else { return }
        
        self.hasViews.toggle()
        
        self.contentView.addSubview(self.stackView)
        self.contentView.addSubview(self.rightIcon)
        
        self.stackView.addArrangedSubview(self.dateLabel)
        self.stackView.addArrangedSubview(self.workTimeLabel)
    }
}
