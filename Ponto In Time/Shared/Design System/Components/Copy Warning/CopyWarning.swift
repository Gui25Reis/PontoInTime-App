/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Componente que lida com o faot de copiar o texto. Todas as ações e UI que sào necessárias estão nessa classe
class CopyWarning: ViewLabel {
    
    /* MARK: - Encapsulamento */
    
    /// Lida com o processo de copiar um texto na área de transferência
    /// - Parameter textToCopy: texto que vai ser copiado
    public func copyHandler(textToCopy: String) {
        UIPasteboard.general.string = textToCopy
    }
    
    
    /// Mostra com animação o aviso de texto copiado
    public func showCopyWarning(for view: UIView) -> Void {
        self.setupView(for: view)
        
        // Mostra a view
        UIView.transition(
            with: self, duration: 0.5, options: .transitionCrossDissolve,
            animations: { self.isHidden = false }
        )
        
        let delay: TimeInterval = 3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    
    /* MARK: - Override */
    
    internal override func setupView() {
        self.isHidden = true
        self.layer.cornerRadius = 5
        self.backgroundColor = .systemFill
    }
    
    
    internal override func setupStaticTexts() {
        self.label.text = "Texto copiado para área de tranferência"
    }
    
    
    internal override func setupFonts() {
        let fontSize = self.superview?.getEquivalent(15) ?? 15
        
        self.label.setupFont(with: FontInfo(fontSize: fontSize, weight: .medium))
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Adiciona e posiciona a view na superview
    /// - Parameter view: superview
    private func setupView(for view: UIView) {
        view.addSubview(self)
        
        let space: CGFloat = view.getEquivalent(10)
        
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -space),
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
        ])
    }
}
