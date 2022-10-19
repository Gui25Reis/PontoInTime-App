/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import func Foundation.NSLocalizedString


extension String {

    /// Pega o texto localizado
    /// - Returns: texto localizado
    internal func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
}
