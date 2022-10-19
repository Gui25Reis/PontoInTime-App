/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Elemento de UI da célula das tabelas da tela de menu inicial
class InfosMenuCell: UITableViewCell, CustomCell {
    
    /* MARK: - Construtor */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Protocolo */
    
    /// Identificador da célula
    static let identifier = "IdInfosMenuCell"
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setupCell(for infos: PointInfo?, with action: ActionType? = nil) {
        var content = self.defaultContentConfiguration()
        
        // Células de ação (botão)
        if let action {
            switch action {
            case .action:
                content.text = "Bater novo ponto"
                content.textProperties.color = .systemBlue
            case .destructive:
                content.text = "Finalizar o dia"
                content.textProperties.color = .systemRed
            }
            
            self.contentConfiguration = content
            return
        }
        
        // Células que mostram informação
        if let infos {
            if let status = infos.status {  // Point
                content.image = self.getImage(for: status)
                self.accessoryType = .disclosureIndicator
            } else {
                if infos.title == "Data" {  // Infos
                    content.image = UIImage(.calendar)
                    content.imageProperties.tintColor = .label
                } else {
                    self.accessoryType = .disclosureIndicator
                }
            }
            
            content.text = infos.title
            content.secondaryText = infos.description
            
            self.contentConfiguration = content
        }
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Pega uma imgam a partir do componente de status (UIView -> UIImage)
    /// - Parameter status: tipo do componente
    /// - Returns: imagem do componente
    private func getImage(for status: StatusViewStyle) -> UIImage {
        let view = StatusView(status: status)
        
        let size = view.squareSize
        view.bounds.size = CGSize(width: size, height: size)

        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { render in
            view.layer.render(in: render.cgContext)
        }
        
        return image
    }
}
