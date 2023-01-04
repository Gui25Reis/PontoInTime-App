/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.NSCoder

import class UIKit.UIView
import class UIKit.NSLayoutConstraint


/// Elemento de UI da célula das tabelas da tela de informações de um ponto
class PointInfoView: UIView, ViewCode, ViewHasTable {
    
    /* MARK: - Atributos */

    /* Protocolo */
    
    // ViewHasTable
    internal var mainTable: CustomTable = CustomTable(style: .justTable)

    
    // ViewCode
    
    /// Constraints dinâmicas que mudam de acordo com o tamanho da tela
    internal var dynamicConstraints: [NSLayoutConstraint] = []
		
    

    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        self.createView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Protocolo */

    internal func setupHierarchy() {
        self.addSubview(self.mainTable)
    }
    
    
    internal func setupView() {
        self.backgroundColor = .systemGray6
    }
    
    
    internal func setupStaticConstraints() {
        let constraintsStreched = self.mainTable.strechToBounds(of: self)
        NSLayoutConstraint.activate(constraintsStreched)
    }
    
	  
    internal func setupDynamicConstraints() {}
    
    internal func setupUI() {}
    
    internal func setupStaticTexts() {}
    
    internal func setupFonts() {}
}
