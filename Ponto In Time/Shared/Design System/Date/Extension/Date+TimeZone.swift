/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import Foundation


extension Date {
    
    /// Adiciona a diferença de horas do fuso horário
    /// - Returns: data com o fuso horário local
    internal func getTimeZoneDifference() -> Date {
        let currentTimeZoneId = TimeZone.autoupdatingCurrent.identifier
        let timezone = TimeZone(identifier: currentTimeZoneId)
        
        if let zone = timezone?.localizedName(for: .shortStandard, locale: nil) {
            if zone.count != 3 {
                // Pegando a diferença
                let hour = Int(zone[4]) ?? 0
                
                var seconds: Int = 0
                if zone.contains(":") {
                    seconds = 30
                }
                
                // Adicionando
                var components = DateComponents()
                
                // Sinal (+ ou -)
                switch zone[3] {
                case "-":
                    components.hour = hour
                    components.second = seconds
                    
                case "+":
                    components.hour = -hour
                    components.second = -seconds
                    
                default:
                    return self
                }
                
                return Calendar.current.date(byAdding: components, to: self) ?? self
            }
        }
        return self
    }
}
