/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct CoreGraphics.CGSize


/// Tipos de telas usadas como referencias para o layout adaptativo
public enum Screens: ScreenSize {
    
    /* MARK: - Casos */
    
    /// A classe (view) do componte (self.view.bounds..)
    case view
    
    /// Um tamanho personalizado
    case custom
    
    /// Tamanho da tela do iPhone12
    case iPhone12
    
    /// Tamanho da tela do iPhone8
    case iPhone8
    
    
    
    /* MARK: - Tamanho da tela */
    
    /// Tamanho de cada caso
    var size: CGSize {
        switch self {
        case .iPhone12:
            return CGSize(width: 390, height: 844)
        case .iPhone8:
            return CGSize(width: 375, height: 667)
        case .view, .custom:
            return CGSize()
        }
    }
}
