/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import struct Foundation.Date
import class Foundation.DateFormatter


extension Date {
    
    /// Cria um formato de data
    /// - Parameter formatType: tipo do formato
    /// - Returns: string da data formatada
    internal func getDateFormatted(with formatType: DateFormatTypes) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.format
        
        return dateFormatter.string(from: self)
    }
    
    
    
    /// Cria uma data a partir da string (string -> date)
    /// - Parameters:
    ///   - format: data em string
    ///   - formatType: tipo do formato
    /// - Returns: data com a string passada
    static func getDate(with format: String, formatType: DateFormatTypes) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.format
        
        return dateFormatter.date(from: format)
    }
}
