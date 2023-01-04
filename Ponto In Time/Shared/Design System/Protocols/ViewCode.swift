/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.NSLayoutConstraint


/// Os tipos que estão de acordo com esse protocolo são componentes UI que são
/// configuradas por código
///
/// Há duas função para serem chamadas em momentos diferentes:
/// - `createView`: no inicializador da estrutura
/// - `dynamicCall`: na funçào `layoutSubviews
protocol ViewCode {
    
    /* MARK: - Atributos */
    
    /// Constraints dinâmicas que mudam de acordo com o tamanho da tela
    var dynamicConstraints: [NSLayoutConstraint] {get set}
        
    
    
    /* MARK: - Métodos */
    
    /// Adiciona os elementos (Views) na tela criando a hierarquia
    func setupHierarchy()
    
    
    /// Confiugurações gerais da view
    func setupView()
    
    
    /// Personalização da UI
    func setupUI()
    
    
    /// Define os textos que são estáticos (os textos em si que vão sempre ser o mesmo)
    func setupStaticTexts()
    
    
    /// Define as fontes e ícones
    func setupFonts()
      
    
    /// Define as constraints que dependem do tamanho da tela
    func setupDynamicConstraints()
    
    
    /// Define as constraints que NÃO dependem do tamanho da tela, que nunca vão mudar.
    func setupStaticConstraints()
}


extension ViewCode {
    
    /// Faz as chamadas necessárias para a criação da view por código
    internal func createView() {
        self.setupHierarchy()
        self.setupView()
        self.setupStaticTexts()
        self.setupStaticConstraints()
    }
    
    
    /// Faz as chamadas necessárias para os momentos que precisam ser atualizados quando há uma mudança na tela
    internal func dynamicCall() {
        self.setupUI()
        self.setupFonts()
        self.setupDynamicConstraints()
    }
}
