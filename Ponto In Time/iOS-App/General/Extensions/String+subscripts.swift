/* Gui Reis    -    gui.sreis25@gmail.com */


extension String {
    
    /* MARK: - Atributos */
    
    /// Tamanho da string
    var length: Int {
        return count
    }
    
    
    
    /* MARK: - Sripts */
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (
            lower: max( 0, min(length, r.lowerBound) ),
            upper: min( length, max(0, r.upperBound) )
        ))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    
    
    /* MARK: - Métodos */
    
    /// Pega o texto a partir de um determinado caractere
    /// - Parameter fromIndex: posição do caractere
    /// - Returns: parte do texto pedido
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    
    /// Pega o texto até um determinado caractere
    /// - Parameter fromIndex: posição do caractere
    /// - Returns: parte do texto pedido
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
}
