/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct CoreGraphics.CGSize


/// Modelo de informações do tamanho da tela e da dimensão para o layout adaptativo.
struct SizeInfo {
    
    /* MARK: - Atributos */
    
    /// Tamanho da tela (largura E altura)
    var screenSize: CGSize
    
    /// Dimensão de referência (largura OU altura)
    var dimension: Dimension
    
    /// Tipo de tela
    var screenType: Screens
    
    
    
    /* MARK: - Construtores */
    
    /// Cria um modelo a partir das informações passadas
    /// - Parameters:
    ///   - screenSize: largura e altura da tela
    ///   - dimension: dimensão de referência
    init(screenSize: CGSize, dimension: Dimension) {
        self.screenSize = screenSize
        self.dimension = dimension
        self.screenType = .custom
    }
    
    
    /// Cria um modelo a partir das informações passadas
    /// - Parameters:
    ///   - screen: tipo de tela
    ///   - dimension: dimensão de referência
    init(screen: Screens, dimension: Dimension) {
        self.screenSize = screen.size
        self.dimension = dimension
        self.screenType = screen
    }
}
