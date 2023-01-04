/* Gui Reis    -    gui.sreis25@gmail.com */


/// Os tipos que estão de acordo com esse protocolos são controllers que possuem uma view
/// com view code.
protocol ControllerActions {
        
    /// Definindo as ações dos botões
    func setupButtonsAction()
    
    
    /// Definindo os delegates, data sources e protocolos
    func setupDelegates()
    
    
    /// Configurações da navigation
    func setupNavigation()
}



extension ControllerActions {
    
    /// Faz as chamdas das funções do protocolo
    internal func setupController() {
        self.setupNavigation()
        self.setupDelegates()
        self.setupButtonsAction()
    }
}
