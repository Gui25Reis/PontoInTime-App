/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct Foundation.URLError


/// Erros que podem acontecer durante ao editar um texto
public enum ErrorTextEdit: Error, ErrorWarnings {
    
    /* MARK: - Casos */
    
    /// String vazia
    case dataIsEmpty
    
    /// Caracteres especiais não são permitidos
    case symbolsNotAllowed
    
    /// Dado não é numérico
    case dataIsNotNumeric
    
    /// Não está de acordo com o intervalo
    case rangeError(range: LimitValues)
    
    
    
    /* MARK: - Variáveis */
    
    public var userWarning: String {
        switch self {
        case .symbolsNotAllowed:
            return "Caracteres especiais não são aceitos. Escreva apenas letras"
        case .dataIsNotNumeric:
            return "O valor digitado não é numérico"
        case .rangeError(let range):
            return "O valor digitado não é permitido. Digite um número entre \(range.min) e \(range.max)"
        case .dataIsEmpty:
            return "O campo não pode ficar vazio."
        }
    }

    
    public var developerWarning: String {
        switch self {
        case .symbolsNotAllowed:
            return "O valor tem algum caractere especiais"
        case .dataIsNotNumeric:
            return "O valor não é um número"
        case .rangeError(let range):
            return "O valor não está dentro do intervalo [\(range.min)...\(range.max)]"
        case .dataIsEmpty:
            return "A string está vazia"
        }
    }
}
