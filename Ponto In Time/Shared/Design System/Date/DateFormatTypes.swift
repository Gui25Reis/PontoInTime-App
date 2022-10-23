/* Gui Reis    -    guis.reis25@gmail.com */


/// Tipode de formatação de data
enum DateFormatTypes {
    
    /// Dia / Mês / Ano
    case dma
    
    /// Hora / Minuto
    case hm
    
    /// Hora / Minuto / Segundo
    case hms
    
    /// Hora em formato de ISO
    case iso
    
    /// Dia + hora + minuto
    case complete
    
    
    
    var format: String {
        switch self {
        case .dma:
            return "dd/MM/yy"
        case .hm:
            return "HH:mm"
        case .hms:
            return "HH:mm:ss"
        case .iso:
            return "dd-MM-yy'T'HH:mm:ssZ"
        case .complete:
            return "dd/MM/yy-HH:mm"
        }
    }
    
}
