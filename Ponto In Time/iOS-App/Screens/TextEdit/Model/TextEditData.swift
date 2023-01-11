/* Gui Reis    -    gui.reis25@gmail.com */


/// Modelo de dados usado na tela de edição de um texto
struct TextEditData {
    
    /* MARK: - Atributos */
    
    /// Título da tela
    let title: String?
    
    /// Dado que vai ser editado
    let defaultData: String?
    
    /// Boleano que indica se o valor é numérico
    let isNumeric: Bool
    
    /// Boleano que indica se o valor possui um botão de deletar
    let isDeletable: Bool
    
    /// Valor máximo de caracteres permitidos
    let maxDataLenght: Int?
    
    /// Intervalo numérico permitido para o valor
    let rangeAllowed: LimitValues?
    
    
    
    /* MARK: - Construtor */
    
    init(
        title: String?, defaultData: String?, isNumeric: Bool,
        maxDataLenght: Int? = nil, rangeAllowed: LimitValues? = nil,
        isDeletable: Bool = false, isNewData: Bool = false
    ) {
        self.title = title
        self.defaultData = defaultData
        self.isNumeric = isNumeric
        self.maxDataLenght = maxDataLenght
        self.rangeAllowed = rangeAllowed
        self.isDeletable = isDeletable
    }
    
    
    init(title: String?, isNumeric: Bool, maxDataLenght: Int? = nil) {
        self.title = title
        self.defaultData = nil
        self.isNumeric = isNumeric
        self.maxDataLenght = maxDataLenght
        self.rangeAllowed = nil
        self.isDeletable = false
    }
}
