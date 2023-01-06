/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIDatePicker


extension UIDatePicker {
    
    /// Pega a data do picker em texto
    /// - Parameter withFormat: formato da data
    /// - Returns: texto da data
    public func getDate(withFormat format: DateFormatTypes) -> String {
        return self.date.getDateFormatted(with: format)
    }
}
