/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.NSCoder
import class UIKit.NSLayoutConstraint
import class UIKit.UIView
import class UIKit.UILabel

import struct CoreGraphics.CGFloat


/// Uma view que possui uma label dentro
///
/// Esse componente é usado principalmente pra criar uma label em que o texto não fique grudada na borda
class ViewLabel: UIView, ViewCode {
    
    /* MARK: - Atributos */

    // Views
    
    /// Label do componente
    public lazy var label: UILabel = {
        let lbl = CustomViews.newLabel()
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    
    // Protocolos
    
    internal lazy var dynamicConstraints: [NSLayoutConstraint] = []
    
    

    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        self.createView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.dynamicCall()
    }
    
    
    
    /* MARK: - Protoolo */
    
    internal func setupHierarchy() {
        self.addSubview(self.label)
    }
    
    
    internal func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    internal func setupStaticConstraints() {
        let space: CGFloat = 5
    
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: space),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: space),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -space),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -space)
        ])
    }
    
    
    internal func setupUI() {}
    
    internal func setupStaticTexts() {}
    
    internal func setupFonts() {}
    
    internal func setupDynamicConstraints() {}
}
