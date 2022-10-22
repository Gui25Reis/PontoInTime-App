/* Gui Reis    -    guis.reis25@gmail.com */


/// Define o estilo do componente de estado
enum StatusViewStyle: CaseIterable {
    
    /* MARK: - Casos */
    
    case start
    case end
        
    
    
    /* MARK: - Variáveis */
    
    /// Cor correspondente ao estado
    var color: AppColors {
        switch self {
        case .start: return .startStatus
        case .end: return .endStatus
        }
    }
    
    
    /// Letra do estado
    var letter: String {
        switch self {
        case .start: return "E"
        case .end: return "S"
        }
    }
    
    
    /// Palavra do estado
    var word: String {
        switch self {
        case .start: return "Entrada".localized()
        case .end: return "Saída".localized()
        }
    }
}
