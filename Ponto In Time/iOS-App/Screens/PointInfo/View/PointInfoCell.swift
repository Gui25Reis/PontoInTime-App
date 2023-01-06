/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.NSLayoutConstraint
import class UIKit.UIView
import struct CoreGraphics.CGFloat


/// Elemento de UI da célula das tabelas da tela de informações de um ponto
class PointInfoCell: TableCell {
    
    /* MARK: - Atributos */
    
    /* Views */
    
    /// Tipo do ponto
    private var statusView: StatusView?
    

    
    /* MARK: - Encapsulamento */
    
    /// Configura o tipo de status do ponto
    public var statusCell: StatusViewStyle = .start {
        didSet { self.setupStatusView(with: self.statusCell) }
    }
    
    
    
    /* MARK: - Configurações */

    /// Configura a view de status de um ponto
    /// - Parameter status: status
    private func setupStatusView(with status: StatusViewStyle) {
        self.statusView = StatusView(status: status)
        self.setupConstraint(for: self.statusView!, with: self.betweenSpace)
    }
    
    
    
    /// Adiciona o elemento na tela e define as constraints
    /// - Parameters:
    ///   - view: view que vai ser configurada
    ///   - constant: espaço lateral
    private func setupConstraint(for view: UIView, with constant: CGFloat) {
        self.contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.rightAnchor.constraint(equalTo: self.secondaryLabel.rightAnchor),
            view.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
