/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIImage
import class UIKit.UIMenu


/// Dados de uma tabela
struct TableData {
    
    /* MARK: - Atributos */
    
    /// Texto principal, que fica na esquerda
    public var primaryText: String?
    
    /// Texto secundário, que fica na direita
    public var secondaryText: String?
    
    /// Imagem que acompanha o texto principal
    public var leftIcon: UIImage?
    
    /// Ícone direito (no fim da célula) padrão da célula
    public var rightIcon: TableIcon?
    
    /// Boleano que indica se a célula é editável
    public var isEditable: Bool
    
    /// Boleano que indica se possui uma switch
    public var hasSwitch: Bool
    
    /// Menu de ações
    public var menu: UIMenu?
    
    /// Tipo de ação
    public var action: ActionType?
    
    
    init() {
        self.primaryText = nil
        self.secondaryText = nil
        self.leftIcon = nil
        self.rightIcon = nil
        self.isEditable = false
        self.hasSwitch = false
        self.menu = nil
        self.action = nil
    }
}
