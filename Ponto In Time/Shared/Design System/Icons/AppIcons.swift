/* Gui Reis    -    gui.sreis25@gmail.com */


/// Ícones usados no projeto
enum AppIcons: CustomStringConvertible {
    
    /* MARK: - Casos */
    
    /* Geral */
    
    /// Símbolo - 􀉉
    case calendar
    
    /// Símbolo - 􀆏
    case options
    
    /// Símbolo - 􀈑
    case delete
    
    /// Símbolo - 􀆊
    case chevron
    
    /// Símbolo - 􀉁
    case copy
    
    /// Símbolo - 􀈕
    case files
    
    /// Símbolo - 􀈄
    case saveToPhotos
    
    /// Símbolo - 􀈂
    case share
    
    
    
    /* Botões */
    
    /// Símbolo - 􀣌
    case settings
    
    /// Símbolo - 􀁍
    case add
    
    
    
    /* Tab */
    
    /// Símbolo - 􀈭
    case historicPage
    
    /// Símbolo - 􀉆
    case menuPage
    
    
    
    /* MARK: - Nome dos Botões */
    
    /// Nome dos botões (SF Symbols)
    var description: String {
        switch self {
        case .calendar: return "calendar"
        case .options: return "chevron.up.chevron.down"
        case .delete: return "trash"
        case .chevron: return "chevron.right"
        case .copy: return "doc.on.doc"
        case .files: return "folder"
        case .saveToPhotos: return "square.and.arrow.down"
        case .share: return "square.and.arrow.up"
            
        case .settings: return "gearshape.fill"
        case .add: return "plus.circle.fill"
            
        case .historicPage: return "archivebox"
        case .menuPage: return "doc.plaintext"
        }
    }
}
