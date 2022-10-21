/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import struct Foundation.URLError


/// Erros que podem acontecer durante o uso do Core Data.
enum ErrorCDHandler: Error, CustomStringConvertible {
    
    /* MARK: - Casos */
    
    case dataNotFound
    case protocolNotSetted
    
    case fetchError
    case saveError
    case deleteError

    
    
    /* MARK: - Variáveis */
    
    /// Descrição do erro para o usuário
    var localizedDescription: String {
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

    
    /// Descrição do erro para o dev
    var description: String {
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
