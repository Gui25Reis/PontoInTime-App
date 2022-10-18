/* Gui Reis    -    guis.reis25@gmail.com */


/// Casos de uso das cores usadas no projeto
enum AppColors {
    
    /* MARK: - Casos */
    
    /* Status */
    
    /// Status: entrada/início
    case startStatus
    
    /// Status: saída/fim
    case endStatus
    
    
    /* System */
    
    /// Cor das safe areas
    case safeAreaColor
    
    
    
    /* MARK: - Nome das cores */
    
    /// Nome da cor
    var colorName: String {
        switch self {
        case .startStatus: return "blue_92B1CE"
        case .endStatus: return "green_A9CE92"
        case .safeAreaColor: return "safeAreaColor"
        }
    }
}
