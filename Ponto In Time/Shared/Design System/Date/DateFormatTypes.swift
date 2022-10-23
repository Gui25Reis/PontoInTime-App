/* Macro - Grupo 05 */


/// Tipode de formatação de data
enum DateFormatTypes {
    
    /// Dia / Mês / Ano
    case dma
    
    /// Hora / Minuto
    case hm
    
    /// Hora / Minuto / Segundo
    case hms
    
    
    var format: String {
        switch self {
        case .dma:
            return "dd/MM/yy"
        case .hm:
            return "HH:mm"
        case .hms:
            return "HH:mm:ss"
        }
    }
    
}
