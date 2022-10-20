/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import UIKit


/// O que essa classe faz?
class PointInfoCell: GeneralTableCell, CustomCell {
    
    /* MARK: - Atributos */
    
    /// Tipo de status
    private let statusView: StatusView = {
        let status = StatusView()
        status.isHidden = true
        return status
    }()
    
    /// Escolha de datas
    private let hourPicker: UIDatePicker = {
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
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Protocolo */
    
    static var identifier: String = "IdPointInfoCell"
    
    
    
    /* MARK: - Encapsulamento */
    
    public var isTimePicker = false {
        didSet {
            self.hourPicker.isHidden = !self.isTimePicker
            self.accessoryView = nil
        }
    }
    
    public var statusCell: StatusViewStyle = .start {
        didSet {
            self.statusView.status = self.statusCell
            self.statusView.isHidden = false
        }
    }
    
    public var hasRightIcon = true {
        didSet {
            self.accessoryView = nil
        }
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
        let image = UIImage.getImage(with: IconInfo(
            icon: .options, size: 13))
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemGray
        
        self.accessoryView = imageView
    }
    
    
    /// Define as constraints que dependem do tamanho da tela
    private func setupDynamicConstraints() {
        if !self.dynamicConstraints.isEmpty {
            NSLayoutConstraint.deactivate(self.dynamicConstraints)
            self.dynamicConstraints.removeAll()
        }
        
        
        if self.isTimePicker {
            let lateral: CGFloat = 16+4
            self.dynamicConstraints = [
                self.hourPicker.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -lateral),
                self.hourPicker.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            ]
            
            NSLayoutConstraint.activate(self.dynamicConstraints)
            return
        }
        
        
        if !self.statusView.isHidden {
            let lateral: CGFloat = 8
            self.dynamicConstraints = [
                self.statusView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -lateral),
                self.statusView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            ]
            
            NSLayoutConstraint.activate(self.dynamicConstraints)
            return
        }
    }
}
