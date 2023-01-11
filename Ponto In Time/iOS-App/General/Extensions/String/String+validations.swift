/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct Foundation.CharacterSet


extension String {
    
    /// Boleano que indica se a string é um número inteiro
    var isNumberInt: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
    
    
    /// Boleano que indica se a string possue apenas letras
    var isAlphabetic: Bool {
        let alphabetic = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        return CharacterSet(charactersIn: self.lowercased()).isSubset(of: alphabetic)
    }
}
