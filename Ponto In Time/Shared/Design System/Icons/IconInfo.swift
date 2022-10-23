/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct CoreGraphics.CGFloat
import class UIKit.UIImage


/// Configurações do ícone de um botão (UIButton)
struct IconInfo {
    
    /* MARK: - Atributos */
    
    let icon: AppIcons
    let size: CGFloat
    let weight: UIImage.SymbolWeight
    let scale: UIImage.SymbolScale
    
    
    
    /* MARK: - Construtores */
    
    init(icon: AppIcons, size: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale? = nil) {
        self.icon = icon
        self.size = size
        self.weight = weight
        
        if let scale {
            self.scale = scale
        } else {
            self.scale = .default
        }
        
    }
    
    
    init(icon: AppIcons, size: CGFloat) {
        self.icon = icon
        self.size = size
        self.weight = .medium
        self.scale = .default
    }
}
