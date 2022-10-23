/* Gui Reis    -    guis.reis25@gmail.com */


/// Qual objetivo desse enum?
enum TableIcon {
    
    /// 
    case chevron
    
    ///
    case contextMenu
    
    ///
    case delete
    
        
    var type: TableIconType {
        switch self {
        case .chevron: return .acessory
        case .contextMenu: return .view
        case .delete: return .view
        }
    }
}


enum TableIconType {
    case acessory
    case view
}
