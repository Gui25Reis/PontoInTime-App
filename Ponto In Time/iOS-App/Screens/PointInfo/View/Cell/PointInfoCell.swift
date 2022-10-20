/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import UIKit


/// O que essa classe faz?
class PointInfoCell: GeneralTableCell, CustomCell {
    
    /* MARK: - Atributos */
    
    /// Tipo de status
    private lazy var statusView: StatusView = {
        let status = StatusView()
        status.isHidden = true
        return status
    }()
    
    /// Escolha de datas
    private lazy var hourPicker: UIDatePicker = {
        let picker = CustomViews.newDataPicker(mode: .time)
        picker.isHidden = true
        return picker
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
    
    static var identifier: String = "IdPointInfoCell"
    
    
    
    /* MARK: - Encapsulamento */
    
    public var isTimePicker = false {
        didSet {
            self.hourPicker.isHidden = !self.isTimePicker
            self.setupUI()
        }
    }
    
    public var statusCell: StatusViewStyle = .start {
        didSet {
            self.statusView.status = self.statusCell
            self.statusView.isHidden = false
        }
    }
    
    

    /* MARK: - Ciclo de Vida */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
        self.setupDynamicConstraints()
        self.setupUI()
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Adiciona os elementos (Views) na tela
    private func setupViews() {
        if self.isTimePicker {
            if self.hourPicker.superview == nil {
                self.contentView.addSubview(self.hourPicker)
            }
        }
        
        if !self.statusView.isHidden {
            if self.statusView.superview == nil {
                self.contentView.addSubview(self.statusView)
            }
        }
    }
    
    
    /// Personalização da UI
    private func setupUI() {
        if !self.isTimePicker {
            let image = UIImageView(image: UIImage(.options))
            image.tintColor = .systemGray
            
            self.accessoryView = image
        } else {
            self.accessoryView = nil
        }
    }
    
    
    /// Define as constraints que dependem do tamanho da tela
    private func setupDynamicConstraints() {
        let lateral: CGFloat = 16 //self.superview?.getEquivalent(16) ?? 16
       
        NSLayoutConstraint.deactivate(self.dynamicConstraints)
        self.dynamicConstraints.removeAll()
        
        if self.isTimePicker {
            self.dynamicConstraints = [
                self.hourPicker.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -lateral),
                self.hourPicker.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            ]
            
            NSLayoutConstraint.activate(self.dynamicConstraints)
            return
        }
        
        
        if !self.statusView.isHidden {
            self.dynamicConstraints = [
                self.hourPicker.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -lateral),
                self.hourPicker.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            ]
            
            NSLayoutConstraint.activate(self.dynamicConstraints)
            return
        }
    }
}
