/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elemento de UI da célula das tabelas da tela de menu inicial
class HistoricCell: UITableViewCell, CustomCell {
    
    /* MARK: - Atributos */
    
    // Views
    
    /// Stacks para colocar as views
    private let stackView = CustomStack(axis: .vertical, sameDimension: .width)
    
    /// Mostra a data
    private let dateLabel = CustomViews.newLabel(align: .left)
    
    /// Mostra a quantidade de horas trabalhadas
    private let workTimeLabel: UILabel = {
        let lbl = CustomViews.newLabel(align: .left)
        lbl.textColor = .systemGray
        return lbl
    }()
   
    
    // Outros

    /// Constraints que vão mudar de acordo com o tamanho da tela
    private var dynamicConstraints: [NSLayoutConstraint] = []
    
    
    
    /* MARK: - Construtor */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Protocolo */
    
    /// Identificador da célula
    static let identifier = "IdHistoricCell"
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Configura a célula a aprtir dos dados da célula
    /// - Parameter data: dados da célula
    public func setupCell(with data: CellData) {
        let fontSize = self.dateLabel.font.pointSize
        
        self.dateLabel.setupTextWithIcon(
            text: FontInfo(text: data.primaryText, fontSize: fontSize, weight: .medium),
            icon: IconInfo(icon: .calendar, size: fontSize)
        )
        
        self.workTimeLabel.text = "Tempo de trabalho: \(data.secondaryText)"
    }
    
    

    /* MARK: - Ciclo de Vida */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupStaticTexts()
        self.setupDynamicConstraints()
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Adiciona os elementos (Views) na tela
    private func setupViews() {    
        self.contentView.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.dateLabel)
        self.stackView.addArrangedSubview(self.workTimeLabel)
    }
    
    
    /// Personalização da UI
    private func setupUI() {
        self.accessoryType = .disclosureIndicator
    }
    
    
    /// Define os textos que são estáticos (os textos em si que vão sempre ser o mesmo)
    private func setupStaticTexts(with dateText: String? = nil) {
        let fontSize: CGFloat = self.superview?.getEquivalent(18) ?? 18
        
        self.dateLabel.setupText(with: FontInfo(
            fontSize: fontSize, weight: .medium
        ))
        
        self.workTimeLabel.setupText(with: FontInfo(
            fontSize: fontSize, weight: .regular
        ))
    }
	  
    
    /// Define as constraints que dependem do tamanho da tela
    private func setupDynamicConstraints() {
        // Espaçamentos
        let lateral: CGFloat = self.superview?.getEquivalent(16) ?? 16
        let lblHeight: CGFloat = self.superview?.getEquivalent(20) ?? 20
        let between: CGFloat = self.stackView.getEqualSpace(for: lblHeight)
        
        
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
    
        self.dynamicConstraints = [
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: between),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: lateral),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -between),
            
            
            self.dateLabel.heightAnchor.constraint(equalToConstant: lblHeight),
            
            self.workTimeLabel.heightAnchor.constraint(equalToConstant: lblHeight),
        ]
        
        NSLayoutConstraint.activate(self.dynamicConstraints)
    }
}
