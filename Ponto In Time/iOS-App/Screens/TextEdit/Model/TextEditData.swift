/* Gui Reis    -    gui.reis25@gmail.com */


/// Modelo de dados usado na tela de edição de um texto
struct TextEditData {
    
    /* MARK: - Atributos */
    
    /// Título da tela
    let title: String
    
    /// Dado que vai ser editado
    let defaultData: String
    
    /// Boleano que indica se o valor é boleano ou não
    let isNumeric: Bool
    
    /// Valor máximo de caracteres permitidos
    let maxDataLenght: Int?
    
    /// Intervalo numérico permitido para o valor
    let rangeAllowed: LimitValues?
    
    
    
    /* MARK: - Construtor */
    
    init(title: String, defaultData: String, isNumeric: Bool, maxDataLenght: Int? = nil, rangeAllowed: LimitValues? = nil) {
        self.title = title
        self.defaultData = defaultData
        self.isNumeric = isNumeric
        self.maxDataLenght = maxDataLenght
        self.rangeAllowed = rangeAllowed
    }
}
