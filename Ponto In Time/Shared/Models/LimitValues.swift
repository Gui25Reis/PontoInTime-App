/* Gui Reis    -    gui.sreis25@gmail.com */


/// Modelo de dados que possui valores limites
public struct LimitValues {
    
    /* MARK: - Atributos */
    
    /// Valor mínimo
    let min: Int
    
    /// Valor máximo
    let max: Int
    
    /// Intervalo de número entre o valor mínimo e máximo
    var range: [ClosedRange<Int>]? {
        return [min...max]
    }
    
    
    
    /* MARK: - Métodos */
    
    /// Verifica se o valor está dentro do intervalo
    /// - Parameter value: valor
    /// - Returns: boleano que indica se está ou não dentro do intervalo
    public func checkInside(value: Int) -> Bool  {
        return value >= min && value <= max
    }
}
