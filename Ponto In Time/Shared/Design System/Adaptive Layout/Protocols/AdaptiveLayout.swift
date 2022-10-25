/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct CoreGraphics.CGSize
import struct CoreGraphics.CGFloat


/// Tipo com métodos para definir o layout adaptativo
///
/// Os tipos que conformam com esse protocolo faz com que o layout adaptativo
/// seja possível e simplificado.
protocol AdaptiveLayout {
    
    /// Converte o valor constante para o layout adaptativo de acordo com a tela de referência
    /// - Parameters:
    ///   - space: Valor constante (.constant: ..)
    ///   - dimension: Dimensão de referência: width OU height (Padrão: width)
    /// - Returns: Valor proporciaonal do layout adaptativo
    func getEquivalent(_ space: CGFloat, dimension: Dimension) -> CGFloat
    
    
    /// Converte o valor constante para o layout adaptativo de acordo com a tela de referência e a tela de propoção
    /// - Parameters:
    ///   - space: Valor constante
    ///   - sizeProporsion:  Dimensões da tela que esta sendo usada
    ///   - screenReference: Dimensões da tela de referência do valor constante
    /// - Returns: Valor do layout adaptativo
    ///
    /// Com essa função é possível definir qual é a tela de referência do valor, mudando a tela de referência padrão, Também é
    /// possível definir qual é as dimensões da tela que vai ser aplicada o valor.
    func getEquivalent(_ space: CGFloat, sizeProporsion: SizeInfo?, screenReference: SizeInfo?) -> CGFloat
    
    
    /// Pega a proporção de uma tela
    /// - Parameter screen: Tipos da tela
    /// - Returns: Altura e largura da tela
    func getScreenSize(from screen: Screens) -> CGSize
    
    
    /// Pega o valor de uma das dimensões (altura OU largura)
    /// - Parameter info: Conjunto de informações sobre a proporção
    /// - Returns: Valor da dimensão
    func getScreenDimension(for info: SizeInfo) -> CGFloat
}
