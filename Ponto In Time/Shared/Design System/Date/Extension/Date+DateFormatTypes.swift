/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.DateFormatter

import struct Foundation.Date
import struct Foundation.TimeZone


extension Date {
    
    /* MARK: - Métodos */
    
    /// Cria um formato de data
    /// - Parameter formatType: tipo do formato
    /// - Returns: string da data formatada
    public func getDateFormatted(with formatType: DateFormatTypes) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.format
        dateFormatter.timeZone = Self.brazilTimeZone
        
        return dateFormatter.string(from: self)
    }
    
    
    /// Cria uma data a partir da string (string -> date)
    /// - Parameters:
    ///   - format: data em string
    ///   - formatType: tipo do formato
    /// - Returns: data com a string passada
    static func getDate(with format: String, formatType: DateFormatTypes) -> Date? {
        var dateString: String = format
        
        if formatType == .complete {
            let today = Date().getDateFormatted(with: .dma)
            dateString = "\(today)-\(dateString)"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.format
        dateFormatter.timeZone = Self.brazilTimeZone
        
        return dateFormatter.date(from: dateString)
    }
}
