/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIColor


/// Tipos de ações das células de uma tabela
enum ActionType {
    
    /* MARK: - Casos */
    /// Uma ação convencional
    case action
    
    /// Uma ação de finalização
    case destructive
    
    
    
    /* MARK: - Variáveis */
    
    /// Cor do texto
    var color: UIColor {
        switch self {
        case .action: return .systemBlue
        case .destructive: return .systemRed
        }
    }
}
