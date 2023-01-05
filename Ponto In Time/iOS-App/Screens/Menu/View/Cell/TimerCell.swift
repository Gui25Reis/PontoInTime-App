/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elemento de UI da célula das tabelas da tela de menu inicial
class TimerCell: UITableViewCell, CustomCell, ViewCode {
    
    /* MARK: - Atributos */
    
    /* Views */
    
    /// Label princiapal
    private lazy var label = CustomViews.newLabel(align: .center)
    
    
    /* Protocolo */
    
    // CustomCell
    static let identifier = "IdTimerCell"
    
    
    // ViewCode
    internal var dynamicConstraints: [NSLayoutConstraint] = []

    
    
    /* MARK: - Construtor */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.createView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Configura o texto da label do timer
    /// - Parameter time: tempo
    public func setupTimer(to time: String) {
        self.label.text = time
    }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.dynamicCall()
    }
    
    
    /* MARK: - Protocolo */

    internal func setupHierarchy() {
        self.contentView.addSubview(self.label)
    }
    
    
    internal func setupView() {
        self.backgroundColor = .systemGray6
    }
    
    
    internal func setupStaticTexts() {
        self.label.text = "00:00:00"
    }
    
    
    internal func setupFonts() {
        self.label.setupFont(with: FontInfo(
            fontSize: 70, weight: .light
        ))
    }
    
    
    internal func setupStaticConstraints() {
        let constraintsStreched = self.label.strechToBounds(of: self.contentView)
        NSLayoutConstraint.activate(constraintsStreched)
    }
    
      
    internal func setupDynamicConstraints() {}
    
    internal func setupUI() {}
}
