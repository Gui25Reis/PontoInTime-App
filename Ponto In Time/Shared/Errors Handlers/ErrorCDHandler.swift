/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct Foundation.URLError


/// Erros que podem acontecer durante o uso do Core Data.
enum ErrorCDHandler: Error, ErrorWarnings {
    
    /* MARK: - Casos */
    
    /// Dado não encontrado
    case dataNotFound
    
    /// Protocolo não foi definido
    case protocolNotSetted
    
    /// Erro na hora de acessar o banco dados
    case fetchError
    
    /// Erro na hora de salvar os dados
    case saveError
    
    /// Erro na hora de deletar
    case deleteError

    
    
    /* MARK: - Variáveis */
    
    var userWarning: String {
        switch self {
        case .dataNotFound:
            return "Não existe esse dado."
        case .fetchError:
            return "Eita, teve um erro dos grandes aqui"
        case .protocolNotSetted:
            return "Os devs erraram aqui"
        case .saveError:
            return "Parece que deu um errinho aqui na hora de salvar"
        case .deleteError:
            return "Ixi, não deu pra deletar"
        }
    }

    
    var developerWarning: String {
        switch self {
        case .dataNotFound:
            return "Não existe esse dado no Core Data."
        case .fetchError:
            return "Problema no fetch"
        case .protocolNotSetted:
            return "Protoco não implementado"
        case .saveError:
            return "Erro na hora de salvar"
        case .deleteError:
            return "Erro na hora de delatar os dados"
        }
    }
}
